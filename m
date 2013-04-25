Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab3DYUkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:40:41 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:52742 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3DYUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:40:39 -0400
Date: Thu, 25 Apr 2013 13:40:33 -0700
From: Tejun Heo <tj@kernel.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, neilb@suse.de, hch@infradead.org, jmoyer@redhat.com,
        hare@suse.de, shaohua.li@intel.com, vgoyal@redhat.com,
        stephenmcameron@gmail.com, linux-kernel@vger.kernel.org,
        lsorense@csclub.uwaterloo.ca
Subject: Re: [RFC PATCH] block: Add new generic block device naming interface
Message-ID: <20130425204033.GB10990@mtj.dyndns.org>
References: <20130425202215.20557.75283.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425202215.20557.75283.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 25, 2013 at 03:22:15PM -0500, Stephen M. Cameron wrote:
> If block drivers could (optionally) share a common device namespace then
> grub could be taught about this common namespace once, and any new block
> device drivers could take advantage of this namespace and grub would
> automatically work with them.

Hmmm... maybe I'm missing something but the names assigned this way
wouldn't have any kind of stability across boots.  Is that good
enough?  But, if so, I'm kinda having hard time understanding what
it'd be able to do which any other name can't do.

Can you please elaborate the use case?

Thanks.

-- 
tejun
