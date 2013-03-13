Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150Ab3CMTBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:01:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53193 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043Ab3CMTBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:01:45 -0400
Date: Wed, 13 Mar 2013 15:01:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Message-ID: <20130313190141.GF5604@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Josh Triplett <josh@joshtriplett.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
References: <20130313185911.GA1446@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313185911.GA1446@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 11:59:13AM -0700, Josh Triplett wrote:
> I frequently test kernel changes by booting them with kvm's -kernel
> option, with -hda pointing to my host system's root filesystem, and
> -snapshot to prevent writing to (and likely corrupting) that root
> filesystem.  I tried this with a kernel built from git commit
> 7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b, with a stock x86-64 "make
> defconfig", and got a kernel panic:

Can you send me the output of "dumpe2fs -h" on your host system's root
file system?

Thanks,

						- Ted
