Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3KOGY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:24:29 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:47087 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3KOGYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:24:21 -0500
Date: Fri, 15 Nov 2013 07:24:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: jerry.hoemann@hp.com
Cc: Pekka Enberg <penberg@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131115062417.GB9237@gmail.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
 <20131113235708.GC25344@anatevka.fc.hp.com>
 <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
 <20131114180455.GA32212@anatevka.fc.hp.com>
 <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
 <20131115005049.GJ5116@anatevka.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115005049.GJ5116@anatevka.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* jerry.hoemann@hp.com <jerry.hoemann@hp.com> wrote:

> On Thu, Nov 14, 2013 at 08:44:04PM +0200, Pekka Enberg wrote:
> > On Thu, Nov 14, 2013 at 8:04 PM,  <jerry.hoemann@hp.com> wrote:
> > > Making this issue a quirk will be a lot more practical.  Its a small, focused
> > > change whose implications are limited and more easily understood.
> > 
> > There's nothing practical with requiring users to pass a kernel option
> > to make kdump work.  It's a workaround, sure, but it's not a proper
> > fix.
> 
> One already has to specify command line arguments to enable kdump. 
> See "crashkernel=" in Documentation/kernel-parameters.txt.

That option is already a usability barrier. Adding yet another 
usability barrier improves things how?

> As i said in an earlier mail we are working w/ distros. [...]

The point being?

> [...]  distros can and do specify lots of interesting command line 
> arguments for their systems.  Distros have tools for configuring 
> kdump. User must already use these tools or manually edit multiple 
> config files, to get kdump to work.  I would work with distros to 
> help integrate this change into their tools.

Here you describe a method that has already successfully cut the kdump 
user base to a fraction of its potential size. Why should we assist to 
that effort of engineered obscurity?

> As i said in earlier mail, i am willing to change implementation to 
> some type of black/white listing.

Is it possible to fix it the way hpa suggested?

Thanks,

	Ingo
