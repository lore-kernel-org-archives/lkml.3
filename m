Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaCBCHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 21:07:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37316 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaCBCHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 21:07:39 -0500
Message-ID: <53129256.6060704@zytor.com>
Date: Sat, 01 Mar 2014 18:07:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53123DCF.7040500@zytor.com> <20140301202139.GA9759@srcf.ucam.org> <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com> <53127AA7.8040700@linux.intel.com> <53127C4B.1060505@zytor.com> <53128DA0.9060105@linux.intel.com>
In-Reply-To: <53128DA0.9060105@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2014 05:47 PM, Li, Aubrey wrote:
> 
> Since we are not able to make things worse, let's make it better. So
> Let's dig into this. For the machine hangs by CF9, it's known to work by
> KBD, right? For the machine hangs by BIOS, do you know which method will
> make reboot work?
> 

No.

> The answer will determine the sequence of the list. If BIOS hangs but
> either of ACPI/KBD/EFI/CF9 works, BIOS is behind of those ways. If BIOS
> hangs, no any other way can make it work. BIOS is still the last way.
> 
> If CF9 hangs while ACPI/KBD hangs as well, and BIOS happened to work(do
> we really have one?), the above list still doesn't make things worse,
> reboot=b and dmidecode table still work.

We obviously have been over this a number of times, and the sad thing is
that we have very limited information.  It is more complex than that,
even... I believe in some cases KBD works but it is slow, and so takes a
while.

	-hpa


