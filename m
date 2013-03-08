Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3CHV0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:26:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:56742 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3CHV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:26:00 -0500
Date: Fri, 8 Mar 2013 22:25:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Tejun Heo <tj@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 04/14] x86, ACPI: make acpi override finding work with
 32bit flat mode
In-Reply-To: <CAE9FiQVXOC71BGSK3t_xg+nP5Qq8ZKoup0sTMJDPnv-y8++=hg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1303082123570.22263@ionos>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org> <1362718720-27048-5-git-send-email-yinghai@kernel.org> <20130308055023.GF14556@mtj.dyndns.org> <CAE9FiQVXOC71BGSK3t_xg+nP5Qq8ZKoup0sTMJDPnv-y8++=hg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,

On Thu, 7 Mar 2013, Yinghai Lu wrote:

> On Thu, Mar 7, 2013 at 9:50 PM, Tejun Heo <tj@kernel.org> wrote:
> > On Thu, Mar 07, 2013 at 08:58:30PM -0800, Yinghai Lu wrote:
> >> We will find acpi tables in initrd during head_32.S in 32bit flat mode.
> >>
> >> So need acpi_initrd_override_find could take phys directly.
> >
> > The patch description doesn't explain even half of what's going on.
> 
> hope HPA could understand.

What the heck? Is HPA your personal decryptor?

I'm really tired of this nonsense. There is a track record of people
complaining about your completely useless and sloppy changelogs and
your unwillingness to properly explain and discuss your patches.

Just to make it clear. We all are able and willing to cope with
developers who are not native english speakers and have limited
language skills. I'm rewriting changelogs on a regular base without
complaining about that.

But that's not the problem at hand. I met you personally at KS and
found out that your english skills are not those of the random Chinese
person. You just prefer to hide your excellent language skills behind
your Chinese name.

That's an utter waste of time and resources!

Please grow up and use your language and technical skills in a way
which does not offend the people you need to interact with.

Seriously, if you can't convince yourself that a proper communication
with maintainers and other developers is a primary task, please don't
be surprised if you end up on the /dev/null filters and auto-NAK bots
of quite a bunch of affected people.

That would be a sad outcome, really. But that's solely your decision.

Thanks,

	tglx
