Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377Ab3EAW2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:28:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49691 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758433Ab3EAW2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:28:52 -0400
Date: Thu, 2 May 2013 00:28:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130501222850.GB15623@pd.tnic>
References: <20130426095140.GA15361@pd.tnic>
 <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org>
 <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com>
 <20130501203500.GC4466@pd.tnic>
 <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
 <20130501211011.GD4466@pd.tnic>
 <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
 <20130501215604.GA15623@pd.tnic>
 <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 03:09:13PM -0700, David Rientjes wrote:
> Unfortunately, the way you're implementing KVM_GUEST_COMMON_OPTIONS
> will typically result in this if the options you "select" get new
> dependencies in the future. So you'll always be updating this option
> constantly with these types of problems.

Ok, so let's step back a bit here: I've added this option with the idea
to have it as a shortcut so that you don't go search for every commodity
option when you want to boot the kernel as a kvm guest. Currently I have
it in all.config when doing randconfig builds here. While I'm doing the
randbuilds, why not boot it in kvm too while at it.

Now, I really fail to see what you describe above to be a fairly normal
use case. I'm sure you can take Kconfig and abuse it so that it screams
all kinds of errors and we know select is evil and Kconfig is not
perfect, etc, etc...

So I'm pretty sure we won't be able to plug all holes. However, let's
try to plug only those which hinder *real* usage instead of contrived
stuff.

So, let's start again: is this something real you're triggering
with some random testing you're doing or are you simply
abusing^Wexperimenting with Kconfig and staring at what breaks?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
