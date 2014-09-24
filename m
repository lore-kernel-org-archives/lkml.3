Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaIXAhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:37:01 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57209 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaIXAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:36:59 -0400
Date: Wed, 24 Sep 2014 09:36:56 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: shmobile: Remove ARCH_HAS_OPP completely
Message-ID: <20140924003656.GB20233@verge.net.au>
References: <1406551632.5397.17.camel@x220>
 <1410511111.31130.4.camel@x220>
 <20140916000916.GD9847@verge.net.au>
 <20140916002333.GI9847@verge.net.au>
 <1411459730.20236.6.camel@x220>
 <CAMuHMdUP_SUjAgjhC3hFXjsSzpR=jCP0iaD5AXLWSUkg0V6hig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUP_SUjAgjhC3hFXjsSzpR=jCP0iaD5AXLWSUkg0V6hig@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:27:37AM +0200, Geert Uytterhoeven wrote:
> On Tue, Sep 23, 2014 at 10:08 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > The Kconfig symbol ARCH_HAS_OPP became redundant in v3.16: commit
> > 049d595a4db3 ("PM / OPP: Make OPP invisible to users in Kconfig")
> > removed the only dependency that used it. Setting it had no effect
> > anymore.
> >
> > So commit 78c5e0bb145d ("PM / OPP: Remove ARCH_HAS_OPP") removed it. For
> > some reason that commit did not remove all select statements for that
> > symbol. These statements are now useless. Remove one from shmobile too.
> 
> The explanation for "some reason" is very simple: new selects were introduced
> in parallel with the removal of the existing ones.
> 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks, I have queued this up for v3.19.
I will push it to a branch that will be included in linux-next
once v3.18-rc1 has been released.
