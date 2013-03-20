Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab3CTEIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:08:44 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:34277 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CTEIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1303192102350.31505@nftneq.ynat.uz>
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
	<20130129014000.GA7003@thunk.org>
	<CAEsagEhZkkr+G0gFr6rnsyjFmCckNMkOnTVcUMvaj8EHD-qGQw@mail.gmail.com>
	<201303200000.33356.Martin@lichtvoll.de>
	<alpine.DEB.2.02.1303192102350.31505@nftneq.ynat.uz>
Date: Tue, 19 Mar 2013 21:08:39 -0700
Message-ID: <CAEsagEipjJpW26Q0=YD7uZZ9QHkA0T1ZteBoVya+OkD8rqVPzQ@mail.gmail.com>
Subject: Re: Tux3 Report: Initial fsck has landed
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: David Lang <david@lang.hm>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, tux3@phunq.net,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, tux3@tux3.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 9:04 PM, David Lang <david@lang.hm> wrote:
> On Wed, 20 Mar 2013, Martin Steigerwald wrote:
>
>> Am Dienstag, 29. Januar 2013 schrieb Daniel Phillips:
>>>
>>> On Mon, Jan 28, 2013 at 5:40 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>>>>
>>>> On Mon, Jan 28, 2013 at 04:20:11PM -0800, Darrick J. Wong wrote:
>>>>>
>>>>> On Mon, Jan 28, 2013 at 03:27:38PM -0800, David Lang wrote:
>>>>>>
>>>>>> The situation I'm thinking of is when dealing with VMs, you make a
>>>>>> filesystem image once and clone it multiple times. Won't that end up
>>>>>> with the same UUID in the superblock?
>>>>>
>>>>> Yes, but one ought to be able to change the UUID a la tune2fs
>>>>> -U.  Even still... so long as the VM images have a different UUID
>>>>> than the fs that they live on, it ought to be fine.
>>>>
>>>> ... and this is something most system administrators should be
>>>> familiar with.  For example, it's one of those things that Norton
>>>> Ghost when makes file system image copes (the equivalent of "tune2fs
>>>> -U random /dev/XXX")
>>>
>>> Hmm, maybe I missed something but it does not seem like a good idea
>>> to use the volume UID itself to generate unique-per-volume metadata
>>> hashes, if users expect to be able to change it. All the metadata hashes
>>> would need to be changed.
>>
>> I believe that is what BTRFS is doing.
>>
>> And yes, AFAIK there is no easy way to change the UUID of a BTRFS
>> filesystems
>> after it was created.
>
> In a world where systems are cloned, and many VMs are started from one
> master copy of a filesystem, a UUID is about as far from unique as anything
> you can generate.
>
> BTRFS may have this problem, but why should Tux3 copy the problem?

Tux3 won't copy that problem. We have enough real problems to deal with
as it is, without manufacturing new ones.

Regards,

Daniel
