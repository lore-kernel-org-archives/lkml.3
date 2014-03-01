Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaCAU1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 15:27:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35290 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaCAU1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 15:27:14 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140301202139.GA9759@srcf.ucam.org>
References: <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53123DCF.7040500@zytor.com> <20140301202139.GA9759@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot sequence loop
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 01 Mar 2014 12:26:40 -0800
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Message-ID: <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

True... trying cf9_cond with low priority probably makes sense.

On March 1, 2014 12:21:39 PM PST, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>On Sat, Mar 01, 2014 at 12:06:39PM -0800, H. Peter Anvin wrote:
>
>> Be careful.  This is *exactly* what I tried back in checkin
>> 14d7ca5c575853664d8fe4f225a77b8df1b7de7d.  We had to back that out
>quite
>> quickly.
>
>It's the difference between trying it before the keyboard controller
>and 
>trying it after the keyboard controller and ACPI. It seems that it
>broke 
>some systems where the keyboard controller worked - if we've hit the 
>keyboard controller and ACPI twice, and the system is still alive, and 
>if we have standard PCI ports, it doesn't seem like poking them is 
>likely to make anything actively worse.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
