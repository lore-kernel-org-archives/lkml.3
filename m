Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3CTK3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:29:47 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55356 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3CTK3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:29:45 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: David Lang <david@lang.hm>
Subject: Re: Tux3 Report: Initial fsck has landed
Date: Wed, 20 Mar 2013 11:29:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc3-tp520; KDE/4.9.5; x86_64; ; )
Cc: tux3@phunq.net, Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, tux3@tux3.org,
        linux-fsdevel@vger.kernel.org
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com> <201303200000.33356.Martin@lichtvoll.de> <alpine.DEB.2.02.1303192102350.31505@nftneq.ynat.uz> (sfid-20130320_112832_061423_065C04E5)
In-Reply-To: <alpine.DEB.2.02.1303192102350.31505@nftneq.ynat.uz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303201129.41996.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 20. März 2013 schrieb David Lang:
> On Wed, 20 Mar 2013, Martin Steigerwald wrote:
> > Am Dienstag, 29. Januar 2013 schrieb Daniel Phillips:
> >> On Mon, Jan 28, 2013 at 5:40 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >>> On Mon, Jan 28, 2013 at 04:20:11PM -0800, Darrick J. Wong wrote:
> >>>> On Mon, Jan 28, 2013 at 03:27:38PM -0800, David Lang wrote:
> >>>>> The situation I'm thinking of is when dealing with VMs, you make a
> >>>>> filesystem image once and clone it multiple times. Won't that end
> >>>>> up with the same UUID in the superblock?
> >>>> 
> >>>> Yes, but one ought to be able to change the UUID a la tune2fs
> >>>> -U.  Even still... so long as the VM images have a different UUID
> >>>> than the fs that they live on, it ought to be fine.
> >>> 
> >>> ... and this is something most system administrators should be
> >>> familiar with.  For example, it's one of those things that Norton
> >>> Ghost when makes file system image copes (the equivalent of "tune2fs
> >>> -U random /dev/XXX")
> >> 
> >> Hmm, maybe I missed something but it does not seem like a good idea
> >> to use the volume UID itself to generate unique-per-volume metadata
> >> hashes, if users expect to be able to change it. All the metadata
> >> hashes would need to be changed.
> > 
> > I believe that is what BTRFS is doing.
> > 
> > And yes, AFAIK there is no easy way to change the UUID of a BTRFS
> > filesystems after it was created.
> 
> In a world where systems are cloned, and many VMs are started from one
> master copy of a filesystem, a UUID is about as far from unique as
> anything you can generate.
> 
> BTRFS may have this problem, but why should Tux3 copy the problem?

I didn´t ask for copying that behavior. I just mentioned it :)

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
