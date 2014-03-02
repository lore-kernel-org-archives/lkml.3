Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaCBCff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 21:35:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37484 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaCBCfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 21:35:34 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140302022334.GA1131@srcf.ucam.org>
References: <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53123DCF.7040500@zytor.com> <20140301202139.GA9759@srcf.ucam.org> <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com> <53127AA7.8040700@linux.intel.com> <53127C4B.1060505@zytor.com> <53128DA0.9060105@linux.intel.com> <53129256.6060704@zytor.com> <20140302022334.GA1131@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot sequence loop
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 01 Mar 2014 18:35:18 -0800
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Message-ID: <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course.  It is primarily a testing problem - we just don't have a compatibility lab to test a bunch of strange hardware.

On March 1, 2014 6:23:34 PM PST, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>On Sat, Mar 01, 2014 at 06:07:18PM -0800, H. Peter Anvin wrote:
>
>> We obviously have been over this a number of times, and the sad thing
>is
>> that we have very limited information.  It is more complex than that,
>> even... I believe in some cases KBD works but it is slow, and so
>takes a
>> while.
>
>And we still have the problem that the keyboard controller sometimes 
>triggers SMM and that then hangs when it hits a piece of hardware in a 
>state it doesn't expect. Sometimes reboot=b or reboot=p is just working
>
>around some assumptions that we could fix more convincingly.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
