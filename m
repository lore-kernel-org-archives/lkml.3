Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbbASHlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:41:44 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:52206 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbASHln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:41:43 -0500
Date: Mon, 19 Jan 2015 07:41:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 09/10] mfd: rtsx: add support for rts525A
Message-ID: <20150119074138.GN3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <06f009ff0bdcb1183412cb0172dc687f0b173747.1421320541.git.micky_ching@realsil.com.cn>
 <20150118111339.GJ3574@x1>
 <54BC71BD.2030202@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BC71BD.2030202@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, 敬锐 wrote:

> 
> On 01/18/2015 07:13 PM, Lee Jones wrote:
> >> @@ -97,7 +97,7 @@ static void rts5249_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
> >> >  	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
> >> >  
> >> >  	if (pm_state == HOST_ENTER_S3) {
> >> >-		if (PCI_PID(pcr) == 0x524A)
> >> >+		if (PCI_PID(pcr) == 0x524A || PCI_PID(pcr) == 0x525A)
> > Shouldn't these be defined somewhere?
> >
> > I have a particular distaste for magic numbers.
> >
> This is the chip ID number, no need define, just using it.
> if we define, it will like RTS525A_PCI_ID, so bad.

Looks good.  Please do that.
-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
