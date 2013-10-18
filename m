Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3JRQYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:24:15 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:37379 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3JRQYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:24:13 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
CC: LKML-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] remove cpqarray from mainline kernel
Thread-Topic: [PATCH 1/1] remove cpqarray from mainline kernel
Thread-Index: AQHOy33Dj6o9AShM8kGldyBHHApEv5n5e5kAgAEpOZA=
Date: Fri, 18 Oct 2013 16:22:07 +0000
Message-ID: <48275AD710FCA34184C2B6186B4016B32D15F735@G6W2491.americas.hpqcorp.net>
References: <20131017175226.GA31535@thumper.usa.hp.com>
 <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org>
 <20131017223616.GB32575@kernel.dk>
In-Reply-To: <20131017223616.GB32575@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Thursday, October 17, 2013 5:36 PM
> To: Andrew Morton
> Cc: Miller, Mike (OS Dev); LKML-scsi; LKML
> Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
> 
> On Thu, Oct 17 2013, Andrew Morton wrote:
> > On Thu, 17 Oct 2013 12:52:26 -0500 Mike Miller <mike.miller@hp.com>
> wrote:
> >
> > > cpqarray hasn't been used in over 12 years. It's doubtful that
> > > anyone still uses the board. It's time the driver was removed from the
> mainline kernel.
> > > The only updates these days are minor and mostly done by people
> outside of HP.
> >
> > It's amazing the weird stuff people get up to.  Perhaps we should
> > disable it in config for a cycle or two, see if that flushes anyone out?
> 
> I think that would be prudent, you never know what people run...
> 
> --
> Jens Axboe

I agree with Andrew's suggestion. Should I submit a patch that only removes cpqarray from config?

-- mikem

