Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaB1Uyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:54:50 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61894 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbaB1Uys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:54:48 -0500
Message-ID: <1393620863.4052.2.camel@x220>
Subject: Re: [Xen-devel] [PATCH] xen: remove XEN_PRIVILEGED_GUEST
From: Paul Bolle <pebolle@tiscali.nl>
To: Vladimir =?UTF-8?Q?=27=CF=86-coder/phcoder=27?= Serbinenko 
	<phcoder@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@linutronix.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Date: Fri, 28 Feb 2014 21:54:23 +0100
In-Reply-To: <530B9FB6.6000909@gmail.com>
References: <201402171223.s1HCNG0S023567@userz7022.oracle.com>
	 <1392642197.13000.20.camel@x220>
	 <20140217144307.GB28658@localhost.localdomain>
	 <1392718467.30073.12.camel@x220>
	 <20140224183939.GA26794@andromeda.dapyr.net> <530B9FB6.6000909@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Feb 2014 20:54:46.0070 (UTC) FILETIME=[4FE6DD60:01CF34C7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 20:38 +0100, Vladimir 'φ-coder/phcoder' Serbinenko
wrote:
> On 24.02.2014 19:39, Konrad Rzeszutek Wilk wrote:
> > On Tue, Feb 18, 2014 at 11:14:27AM +0100, Paul Bolle wrote:
> >> And that commit was reverted a week later in grub commit
> >> faf4a65e1e1ce1d822d251c1e4b53d96ec7faec5 ("Revert grub-file usage in
> >> grub-mkconfig."), see
> >> http://git.savannah.gnu.org/cgit/grub.git/commit/util/grub.d/20_linux_xen.in?id=faf4a65e1e1ce1d822d251c1e4b53d96ec7faec5 .
> >>
> >> That commit has no explanation (other than its one line summary). So
> >> we're left guessing why this was done. Luckily, it doesn't matter here,
> >> because the test for CONFIG_XEN_PRIVILEGED_GUEST is superfluous.
> > 
> > How about we ask Vladimir?
> > 
> > Vladimir - could you shed some light on it? Thanks!
> > 
> CONFIG_XEN_PRIVILEGED_GUEST is not present on Linux even though it
> should be. The test was removed to accomodate this.

It's not clear to me what this means, sorry. 

> The usage of grub-file was removed because it wasn't release-ready.

I see.

Thanks.


Paul Bolle

