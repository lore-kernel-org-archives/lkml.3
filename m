Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaDQWUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 18:20:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58271 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaDQWUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 18:20:31 -0400
Date: Fri, 18 Apr 2014 00:20:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Owen Kibel <qmewlo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140417222028.GD27852@pd.tnic>
References: <20140417102442.GA8215@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
 <20140417152611.GD4321@pd.tnic>
 <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
 <20140417192330.GE4321@pd.tnic>
 <CA+55aFyz62W7CD9=9p9OxKuFs9Rck_p93E_40CqLat1HvDdf0Q@mail.gmail.com>
 <20140417194241.GF4321@pd.tnic>
 <20140417205807.GA27852@pd.tnic>
 <CAK7FoDt6tnknX7cioe7=2svVksyAyLUtoZX_oprzJNxoHZEpdw@mail.gmail.com>
 <20140417213012.GC27852@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140417213012.GC27852@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:30:12PM +0200, Borislav Petkov wrote:
> This is most likely unrelated and is caused by the preemption checks
> added to __this_cpu_* in 188a81409ff7. If you'd like to debug this
> further, please send a full dmesg:
> 
> dmesg > dmesg.log
> 
> Privately is fine too.

Ok, thanks for the dmesg. Replying to the thread with everybody:

The splat Owen is seeing is the same as this one at the beginning of
this thread here:

http://lkml.kernel.org/r/8761m7lm3j.fsf@canonical.com

which has a viable fix. Btw, those two splats happen on HP notebooks.

Ok, good, I think we're all solved. Phew :-)

Thanks to all for their help.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
