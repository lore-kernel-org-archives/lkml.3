Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaDRJWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:22:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39685 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaDRJWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:21 -0400
Date: Fri, 18 Apr 2014 11:22:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Owen Kibel <qmewlo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140418092219.GA4385@pd.tnic>
References: <20140417152611.GD4321@pd.tnic>
 <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
 <20140417192330.GE4321@pd.tnic>
 <CA+55aFyz62W7CD9=9p9OxKuFs9Rck_p93E_40CqLat1HvDdf0Q@mail.gmail.com>
 <20140417194241.GF4321@pd.tnic>
 <20140417205807.GA27852@pd.tnic>
 <CAK7FoDt6tnknX7cioe7=2svVksyAyLUtoZX_oprzJNxoHZEpdw@mail.gmail.com>
 <20140417213012.GC27852@pd.tnic>
 <20140417222028.GD27852@pd.tnic>
 <20140418080716.GA14280@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140418080716.GA14280@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 10:07:16AM +0200, Ingo Molnar wrote:
> Okay, so AFAICS the fix in x86/urgent isn't wrong functionally, it's
> just that the changelog incorrectly claims the raw-spinlock use is a
> bug causing a problem here.
>
> Still that raw spinlock is bogus and might be hiding other problems,
> so we can keep the x86/urgent change (ea431643d6c3) as-is and I'll get
> it to Linus later today ...

Ok.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
