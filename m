Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaFCXgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:36:16 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59334 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaFCXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:36:15 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Scheduling while atomic regression in Linus's next branch
From: Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (11D201)
In-Reply-To: <20140603233356.GA25980@thunk.org>
Date: Tue, 3 Jun 2014 17:36:09 -0600
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
Message-Id: <089C6A3C-23AE-43C4-9213-56DF5E5EFA76@kernel.dk>
References: <20140603233356.GA25980@thunk.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 3, 2014, at 5:33 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> Using 3.15.0-rc8-04539-gc84a1e3, mke2fs failed while trying to fsync
> to a block device (probably /dev/vdc).
> 
> I haven't tried to bisect this yet, but this seems pretty blatent.
> Is this a known bug?

It is, fix is queued up, will send it in later today. 


