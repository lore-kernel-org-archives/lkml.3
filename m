Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaBDGbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:31:51 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37699 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaBDGbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:31:46 -0500
Date: Mon, 3 Feb 2014 22:31:40 -0800
From: Matt Wilson <msw@linux.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Roger Pau Monne <roger.pau@citrix.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Matthew Rushton <mrushton@amazon.com>,
        Matt Wilson <msw@amazon.com>
Subject: Re: [Xen-devel] xen-blkback: bug fixes
Message-ID: <20140204063139.GA19177@u109add4315675089e695.ant.amazon.com>
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
 <20140128193837.GA32072@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128193837.GA32072@andromeda.dapyr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 03:38:37PM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 28, 2014 at 06:43:32PM +0100, Roger Pau Monne wrote:
> > blkback bug fixes for memory leaks (patches 1 and 2) and a race 
> > (patch 3).
> 
> They all look OK to me. I've stuck them in my 'stable/for-jens-3.14'
> branch and are testing them now (hadn't pushed it yet).
> 
> Matt and Matt,
> 
> Could you take a look at the other two patches as well?

Sure, though somehow you didn't address your message to us, so I
didn't see it until today.

Matt Rushton did some review and testing on an earlier version that
came out fine. We'll give the final series a test since there was
still a bit of rework.

--msw

> David, Boris,
> 
> Are you OK with pushing those patches out to Jens Axboe if nobody
> gives an NACK by Friday?
