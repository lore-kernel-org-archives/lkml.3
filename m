Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaDYNPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:15:53 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:58537 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaDYNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:15:30 -0400
Date: Fri, 25 Apr 2014 15:15:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Owen Kibel <qmewlo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140425131525.GA27668@gmail.com>
References: <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
 <20140417192330.GE4321@pd.tnic>
 <CA+55aFyz62W7CD9=9p9OxKuFs9Rck_p93E_40CqLat1HvDdf0Q@mail.gmail.com>
 <20140417194241.GF4321@pd.tnic>
 <20140417205807.GA27852@pd.tnic>
 <CAK7FoDt6tnknX7cioe7=2svVksyAyLUtoZX_oprzJNxoHZEpdw@mail.gmail.com>
 <20140417213012.GC27852@pd.tnic>
 <20140417222028.GD27852@pd.tnic>
 <20140418080716.GA14280@gmail.com>
 <20140425084723.GA7455@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425084723.GA7455@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chen, Gong <gong.chen@linux.intel.com> wrote:

> On Fri, Apr 18, 2014 at 10:07:16AM +0200, Ingo Molnar wrote:
> > Okay, so AFAICS the fix in x86/urgent isn't wrong functionally, it's 
> > just that the changelog incorrectly claims the raw-spinlock use is a 
> > bug causing a problem here.
> > 
> > Still that raw spinlock is bogus and might be hiding other problems, 
> > so we can keep the x86/urgent change (ea431643d6c3) as-is and I'll get 
> > it to Linus later today ...
> > 
> > Thanks,
> > 
> > 	Ingo
> Hi, Ingo
> 
> We ever had a patch(59d958d2c7) to make spinlock -> raw_spinlock.
> Would you please explain it a little more why you revert it?

It was years ago and I forgot about that. Should be redone I guess.

Thanks,

	Ingo
