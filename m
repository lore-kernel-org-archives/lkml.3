Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaE1FTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 01:19:22 -0400
Received: from verein.lst.de ([213.95.11.211]:33732 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaE1FTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 01:19:21 -0400
Date: Wed, 28 May 2014 07:19:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: blk-mq: refactor request allocation
Message-ID: <20140528051919.GA21566@lst.de>
References: <1401217190-32453-1-git-send-email-hch@lst.de> <5384FC60.1070103@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5384FC60.1070103@fb.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:58:08PM -0600, Jens Axboe wrote:
> On 05/27/2014 12:59 PM, Christoph Hellwig wrote:
> > This series streamlines the request allocation path.
> > 
> 
> Series looks innocuous enough to me, but it's about a 1.5% performance
> drop here with an actual device. These tests are very stable, anything
> over ~0.1% is definitely outside of noise. I repeated and rebooted a few
> times and tested both, it's persistent. No smoking guns in the profile.

Can you do a bisect to narrow it down to one of the patches?
