Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3BBBZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 20:25:32 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47583 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab3BBBZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 20:25:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAH+dOxLDVsrmuh2b+RVxwOd0+JOQ+LsbuRYB5zqTE7DnoA+XTA@mail.gmail.com>
References: <20130202004459.GA4760@blackbox.djwong.org>
	<CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
	<CAH+dOxLDVsrmuh2b+RVxwOd0+JOQ+LsbuRYB5zqTE7DnoA+XTA@mail.gmail.com>
Date: Fri, 1 Feb 2013 17:25:29 -0800
Message-ID: <CAH+dOxKUdxF1Ds9ogncBF1K-A979j46SqGq1rVeqii8LtgHxQw@mail.gmail.com>
Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD caching
 software for Linux kernel
From: Kent Overstreet <koverstreet@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Amit Kale <akale@stec-inc.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Warr <jason@warr.net>, thornber@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, where's the end user documentation?

On Fri, Feb 1, 2013 at 5:23 PM, Kent Overstreet <koverstreet@google.com> wrote:
> On Fri, Feb 1, 2013 at 4:57 PM, Michel Lespinasse <walken@google.com> wrote:
>> On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>> This is a patch to migrate STEC's enhanceio driver out of their github
>>> repository and into the staging tree.  From their README:
>>>
>>> "EnhanceIO driver is based on EnhanceIO SSD caching software product developed
>>> by STEC Inc. EnhanceIO was derived from Facebook's open source Flashcache
>>> project. EnhanceIO uses SSDs as cache devices for traditional rotating hard
>>> disk drives (referred to as source volumes throughout this document).
>>> EnhanceIO can work with any block device, be it an entire physical disk, an
>>> individual disk partition,  a RAIDed DAS device, a SAN volume, a device mapper
>>> volume or a software RAID (md) device."
>>
>> What's your take on the benefits of this vs bcache ?
>
> I've been trying to review it it for cache coherency and consistency
> wrt. power failures, but the complete lack of high level documentation
> is making that difficult.
>
> I saw some benchmarks the other day where on writes EIO was faster
> than the raw device, which was... suspicious.
