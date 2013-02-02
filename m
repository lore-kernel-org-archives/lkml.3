Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3BBA6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:58:01 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:50907 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3BBA6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130202004459.GA4760@blackbox.djwong.org>
References: <20130202004459.GA4760@blackbox.djwong.org>
Date: Fri, 1 Feb 2013 16:57:59 -0800
Message-ID: <CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD caching
 software for Linux kernel
From: Michel Lespinasse <walken@google.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Amit Kale <akale@stec-inc.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Warr <jason@warr.net>, thornber@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> This is a patch to migrate STEC's enhanceio driver out of their github
> repository and into the staging tree.  From their README:
>
> "EnhanceIO driver is based on EnhanceIO SSD caching software product developed
> by STEC Inc. EnhanceIO was derived from Facebook's open source Flashcache
> project. EnhanceIO uses SSDs as cache devices for traditional rotating hard
> disk drives (referred to as source volumes throughout this document).
> EnhanceIO can work with any block device, be it an entire physical disk, an
> individual disk partition,  a RAIDed DAS device, a SAN volume, a device mapper
> volume or a software RAID (md) device."

What's your take on the benefits of this vs bcache ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
