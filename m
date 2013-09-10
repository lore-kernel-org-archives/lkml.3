Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3IJJqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:46:09 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51574 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3IJJqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:46:04 -0400
Date: Tue, 10 Sep 2013 10:45:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: wwang <wei_wang@realsil.com.cn>
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, micky_ching@realsil.com.cn
Subject: Re: [PATCH] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130910094557.GC1456@lee--X1>
References: <1378804142-28483-1-git-send-email-wei_wang@realsil.com.cn>
 <522EE258.20403@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <522EE258.20403@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, wwang wrote:

> 于 2013年09月10日 17:09, wei_wang@realsil.com.cn 写道:
> > From: Wei WANG <wei_wang@realsil.com.cn>
> >
> > In some platforms, specially Thinkpad series, rts5249 won't be
> > initialized properly. So we need adjust some phy parameters to
> > improve the compatibility issue.
> 
> Hi all:
> 
> Sorry, forget to modify the subject prefix. Please ignore this patch. I
> will resend another one.

Although it's important to put the version in the subject line of
resubmissions, it's probably not important enough to send twice. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
