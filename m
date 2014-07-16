Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaGPVfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:35:16 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62423 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751359AbaGPVfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:35:11 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: Re: linux-next: manual merge of the pm tree with the ia64 tree
Date: Wed, 16 Jul 2014 23:53:26 +0200
Message-ID: <1945215.v4beMAkkaN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802641B27@SHSMSX101.ccr.corp.intel.com>
References: <20140715135620.2e68ee57@canb.auug.org.au> <2083565.B2UV9LfG6j@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E8802641B27@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2014 03:06:13 AM Zheng, Lv wrote:
> Hi,
> 
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Tuesday, July 15, 2014 8:15 PM
> > 
> > On Tuesday, July 15, 2014 01:56:20 PM Stephen Rothwell wrote:
> > >
> > > --Sig_/Cs291xJCrI1kc_+PiCdNT0M
> > > Content-Type: text/plain; charset=US-ASCII
> > > Content-Transfer-Encoding: quoted-printable
> > >
> > > Hi Rafael,
> > >
> > > Today's linux-next merge of the pm tree got a conflict in
> > > drivers/acpi/acpi_extlog.c between commits 2dfb7d51a61d ("trace, RAS:
> > > Add eMCA trace event interface") and d6cae935ec5b ("trace, eMCA: Add a
> > > knob to adjust where to save event log") from the ia64 tree and commit
> > > 0a00fd5e20fd ("ACPICA: Restore error table definitions to reduce code
> > > differences between Linux and ACPICA upstream") from the pm tree.
> > >
> > > I fixed it up (hopefully - see below) and can carry the fix as
> > > necessary (no action is required).
> > 
> > Thanks for fixing this up!
> > 
> > Lv, can you please check if acpi_extlog.c is fine in linux-next?
> 
> I checked.
> 
> There is no problem in rafael/linux-pm.git/linux-next branch.
> The 2 commits:
>   trace, RAS: Add eMCA trace event interface
>   trace, eMCA: Add a knob to adjust where to save event log
> are not in torvalds/linux.git/master branch, I found them in aegl/linux.git/next branch.
> 
> So if torvalds/linux.git/master merges rafael/linux-pm.git/linux-next before merging aegl/linux.git/next, we will need the following fix.
> And the following collision fix is correct.

Thanks for checking!

Rafael

