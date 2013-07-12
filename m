Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab3GLBtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:49:31 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37049 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3GLBt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:49:29 -0400
Date: Thu, 11 Jul 2013 21:49:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ext4: fix ext4_get_group_number() at cluster
 boundaries
Message-ID: <20130712014925.GC31005@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Whitcroft <apw@canonical.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1373542128-15662-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373542128-15662-1-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:28:48PM +0100, Andy Whitcroft wrote:
> Commit bd86298e60b8 introduced a new optimisation for callers who needed
> only the ext4 group number and not the block offset within.  It hand
> calculates the group number from the block in the common case, falling
> back to the original group offset implementation otherwise.

A fix for this problem is already in the ext4 tree, and will be pushed
to Linus shortly:

http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=960fd856fdc3b08b3638f3f9b6b4bfceb77660c7

Cheers,

					- Ted


