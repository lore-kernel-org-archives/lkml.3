Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbbASHiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:38:46 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48322 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbASHip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:38:45 -0500
Date: Mon, 19 Jan 2015 07:38:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 08/10] mfd: rtsx: add support for rts524A
Message-ID: <20150119073840.GL3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <007fcaa1986088c968cd4d1627c294a55df73e9f.1421320541.git.micky_ching@realsil.com.cn>
 <20150118122055.GK3574@x1>
 <54BC756D.1000102@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BC756D.1000102@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, 敬锐 wrote:

> 
> On 01/18/2015 08:20 PM, Lee Jones wrote:
> >> +};
> >> >+
> >> >+void rts524a_init_params(struct rtsx_pcr *pcr)
> >> >+{
> >> >+	rts5249_init_params(pcr);
> >> >+
> >> >+	pcr->ops = &rts524a_pcr_ops;
> >> >+}
> > I see a couple of these now.  Why don't you make 'ops' a parameter of
> > *_init_params().
> >
> *_init_params() is called from rtsx_pcr.c, and the ops parameter should
> be static, if we make ops as a parameter, the rts524a_pcr_ops defination
> should move to rtsx_pcr.c, not reasonable.

Fair enough.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
