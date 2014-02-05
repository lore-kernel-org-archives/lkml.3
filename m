Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaBERcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:32:07 -0500
Received: from one.firstfloor.org ([193.170.194.197]:35065 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaBERcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:32:05 -0500
Date: Wed, 5 Feb 2014 18:32:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86: Disable CONFIG_X86_DECODER_SELFTEST in
 allmod/allyesconfigs
Message-ID: <20140205173202.GL11821@two.firstfloor.org>
References: <alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
 <CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
 <20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
 <alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
 <20140204090809.GA19156@gmail.com>
 <CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
 <87fvny238i.fsf@tassilo.jf.intel.com>
 <CA+55aFzDp70dv=eCwuOr=gAPVBKaDVUyvFbqedrRJXhUDeHnfQ@mail.gmail.com>
 <20140205055137.GB30094@gmail.com>
 <CAP=VYLrqOMw2ZYoeWnNK6r80_FmmCmdne1yA=VTaU1Q8phzaVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLrqOMw2ZYoeWnNK6r80_FmmCmdne1yA=VTaU1Q8phzaVg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For the record, even with a (currently) modern CPU such as a
> Xeon E5-2630 @ 2.30GHz, the script takes 4m30s on 3.14-rc1
> i386 allyesconfig.  And since it runs single threaded at the end
> of the build, it really adds that amount to the wall time spent
> on the build. So enthusiastically Acked, FWIW.

I suppose we could just multi thread it. It should 
"embarassingly" scale without problems. But turning it off by default is a
first step.

-Andi
