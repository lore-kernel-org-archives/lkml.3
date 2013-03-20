Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab3CTPAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:00:25 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52638 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3CTPAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:00:23 -0400
Date: Wed, 20 Mar 2013 01:54:53 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Tux3 Report: Initial fsck has landed
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: tux3@phunq.net, Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Lang <david@lang.hm>, linux-kernel@vger.kernel.org,
        tux3@tux3.org, linux-fsdevel@vger.kernel.org
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
	<20130129014000.GA7003@thunk.org>
	<CAEsagEhZkkr+G0gFr6rnsyjFmCckNMkOnTVcUMvaj8EHD-qGQw@mail.gmail.com>
	<201303200000.33356.Martin@lichtvoll.de>
In-Reply-To: <201303200000.33356.Martin@lichtvoll.de> (from
	Martin@lichtvoll.de on Tue Mar 19 18:00:32 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1363762493.15703.46@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 06:00:32 PM, Martin Steigerwald wrote:
> Am Dienstag, 29. Januar 2013 schrieb Daniel Phillips:
> > On Mon, Jan 28, 2013 at 5:40 PM, Theodore Ts'o <tytso@mit.edu>  
> wrote:
> > > On Mon, Jan 28, 2013 at 04:20:11PM -0800, Darrick J. Wong wrote:
> > >> On Mon, Jan 28, 2013 at 03:27:38PM -0800, David Lang wrote:
> > >> > The situation I'm thinking of is when dealing with VMs, you  
> make a
> > >> > filesystem image once and clone it multiple times. Won't that  
> end up
> > >> > with the same UUID in the superblock?
> > >>
> > >> Yes, but one ought to be able to change the UUID a la tune2fs
> > >> -U.  Even still... so long as the VM images have a different UUID
> > >> than the fs that they live on, it ought to be fine.
> > >
> > > ... and this is something most system administrators should be
> > > familiar with.  For example, it's one of those things that Norton
> > > Ghost when makes file system image copes (the equivalent of  
> "tune2fs
> > > -U random /dev/XXX")
> >
> > Hmm, maybe I missed something but it does not seem like a good idea
> > to use the volume UID itself to generate unique-per-volume metadata
> > hashes, if users expect to be able to change it. All the metadata  
> hashes
> > would need to be changed.
> 
> I believe that is what BTRFS is doing.
> 
> And yes, AFAIK there is no easy way to change the UUID of a BTRFS  
> filesystems
> after it was created.

I'm confused, http://tux3.org/ lists a bunch of dates from 5 years ago,  
then nothing. Is this project dead or not?

Rob