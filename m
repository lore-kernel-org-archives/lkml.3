Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaKKLjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:39:22 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:39148 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaKKLjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:39:18 -0500
Date: Tue, 11 Nov 2014 11:38:31 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Message-ID: <20141111113831.1119720e@alan.etchedpixels.co.uk>
In-Reply-To: <546126FF.3070600@zytor.com>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
	<20141109182231.GA29337@pd.tnic>
	<1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>
	<201411101723.49197@pali>
	<5460EB92.1090501@gmail.com>
	<20141110170417.GA17286@srcf.ucam.org>
	<5461220E.20605@gmail.com>
	<546126FF.3070600@zytor.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > look further into the options I have set in my kernel build, I may have
> > changed something else without remembering between booting with and
> > without the CSM enabled.
> > 
> 
> It could also be that the non-CSM BIOS somehow remaps the CMOS registers.

I don't believe there is anything which prevents the CSM from faking a
CMOS clock using SMM from whatever is actually in the hardware.

Alan
