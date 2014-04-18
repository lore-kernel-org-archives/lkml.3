Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaDRPZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:25:06 -0400
Received: from imap.thunk.org ([74.207.234.97]:48324 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaDRPZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:25:00 -0400
Date: Fri, 18 Apr 2014 11:24:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [ext4] BUG: sleeping function called from invalid context at
 fs/ext4/ext4_jbd2.c:252
Message-ID: <20140418152456.GA31301@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>,
	LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
	Linux Ext4 <linux-ext4@vger.kernel.org>
References: <20140417033346.GA8702@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417033346.GA8702@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:33:46AM +0800, Fengguang Wu wrote:
> 
> FYI, we noticed that simple dd write can trigger the below BUG in
> commit 208b9cc3a32f29b8a9bba682b5bfbb962bc9892d ("ext4: add a new
> spinlock i_raw_lock to protect the ext4's raw inode")

Yes, that was a buggy version of the patch that I thought was fairly
quickly replaced with a new version; something must have gone wrong
with how I pushed out my git branches.  Anyway I'm pretty sure it's
not there on ext4.git any more.  Let me know if you're still seeing
it, and from which branch.

Cheers,

					- Ted
