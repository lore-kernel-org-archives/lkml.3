Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaKKLqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:46:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49991 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbaKKLqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:46:10 -0500
Date: Tue, 11 Nov 2014 12:46:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Message-ID: <20141111114605.GE31490@pd.tnic>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
 <20141109182231.GA29337@pd.tnic>
 <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>
 <201411101723.49197@pali>
 <5460EB92.1090501@gmail.com>
 <20141110170417.GA17286@srcf.ucam.org>
 <5461220E.20605@gmail.com>
 <546126FF.3070600@zytor.com>
 <20141111113831.1119720e@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141111113831.1119720e@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 11:38:31AM +0000, One Thousand Gnomes wrote:
> I don't believe there is anything which prevents the CSM from faking a
> CMOS clock using SMM from whatever is actually in the hardware.

HPET in SMM? Oh, sure, definitely.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
