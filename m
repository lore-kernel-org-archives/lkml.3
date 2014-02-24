Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaBXSks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:40:48 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:40274 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaBXSkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:40:47 -0500
Date: Mon, 24 Feb 2014 14:39:39 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Paul Bolle <pebolle@tiscali.nl>, phcoder@gmail.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@linutronix.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: remove XEN_PRIVILEGED_GUEST
Message-ID: <20140224183939.GA26794@andromeda.dapyr.net>
References: <201402171223.s1HCNG0S023567@userz7022.oracle.com> <1392642197.13000.20.camel@x220> <20140217144307.GB28658@localhost.localdomain> <1392718467.30073.12.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392718467.30073.12.camel@x220>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:14:27AM +0100, Paul Bolle wrote:
> On Mon, 2014-02-17 at 09:43 -0500, Konrad Rzeszutek Wilk wrote:
> > On Mon, Feb 17, 2014 at 02:03:17PM +0100, Paul Bolle wrote:
> > > On Mon, 2014-02-17 at 07:23 -0500, Konrad Rzeszutek Wilk wrote:
> > > > On Feb 16, 2014 3:07 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > > > Please look in the grub git tree. They have fixed their code to not do
> > > > this anymore. This should be reflected in the patch description.
> > > 
> > > Thanks, I didn't know that. That turned out to be grub commit
> > > ec824e0f2a399ce2ab3a2e3353d372a236595059 ("Implement grub_file tool and
> > > use it to implement generating of config"), see
> > > http://git.savannah.gnu.org/cgit/grub.git/commit/util/grub.d/20_linux_xen.in?id=ec824e0f2a399ce2ab3a2e3353d372a236595059
> 
> And that commit was reverted a week later in grub commit
> faf4a65e1e1ce1d822d251c1e4b53d96ec7faec5 ("Revert grub-file usage in
> grub-mkconfig."), see
> http://git.savannah.gnu.org/cgit/grub.git/commit/util/grub.d/20_linux_xen.in?id=faf4a65e1e1ce1d822d251c1e4b53d96ec7faec5 .
> 
> That commit has no explanation (other than its one line summary). So
> we're left guessing why this was done. Luckily, it doesn't matter here,
> because the test for CONFIG_XEN_PRIVILEGED_GUEST is superfluous.

How about we ask Vladimir?

Vladimir - could you shed some light on it? Thanks!

> 
> Anyhow, I hope to submit a second version of this patch later this day.
> 
> 
> Paul Bolle
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
