Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3DUSKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 14:10:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33287 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab3DUSKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 14:10:41 -0400
Date: Sun, 21 Apr 2013 20:10:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421181035.GC4559@pd.tnic>
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130421165653.GA4623@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 06:56:54PM +0200, Borislav Petkov wrote:
> Ok, let me try to disable the soundcard in the BIOS.

Ok, there's no warning message anymore but maybe a dozen of seconds
delay before the machine is actually powered off.

"...
ACPI: Preparing to enter system sleep state S5
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<a bunch of seconds of doing nothing>
...
<machine powers off>"

So could it be that some RCU cleanup stuff is going on during that time?

I mean, the issue is not that big of a deal - when the box resumes, the
sound card works just fine so...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
