Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaHHG6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:58:32 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:39842 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHHG62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:58:28 -0400
Message-ID: <1407481104.2513.41.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/4 v2] brd: Add getgeo to block ops
From: Davidlohr Bueso <davidlohr@hp.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Thu, 07 Aug 2014 23:58:24 -0700
In-Reply-To: <CA+uBny4uWrGpb_fNUW5Z6JDw5ZWTG9L5_mh18iMVmDBmmRguaQ@mail.gmail.com>
References: <53E21125.9080308@plexistor.com>
	 <53E211D9.7030102@plexistor.com> <53E3871C.4020008@plexistor.com>
	 <20140807192032.70e71fa7@alan.etchedpixels.co.uk>
	 <CA+uBny4uWrGpb_fNUW5Z6JDw5ZWTG9L5_mh18iMVmDBmmRguaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-08 at 09:52 +0300, Boaz Harrosh wrote:
> On Thu, Aug 7, 2014 at 9:20 PM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
> > On Thu, 07 Aug 2014 17:03:08 +0300
> > Boaz Harrosh <boaz@plexistor.com> wrote:
> >
> >> From: Boaz Harrosh <boaz@plexistor.com>
> >>
> >> Some programs like fdisk, require HDIO_GETGEO to work, which requires we
> >> implement getgeo.
> >>
> >> We set all hd_geometry members to 1, because this way fdisk
> >> math will not try its crazy geometry math and get stuff totally wrong.
> >
> > If you are running a new storage system for god sake don't use DOS
> > partitioning, use GPT or something sane.
> >
> 
> I am always using GPT, on all my systems for few years now.
> Fdisk  works exactly the same, regardless of format, regarding alignment
> and start sectors.

Yes, fdisk now supports GPT, for about the past two years now. In fact
it has been completely rewritten.

