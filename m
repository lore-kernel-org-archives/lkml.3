Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaBRBoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:44:04 -0500
Received: from imap.thunk.org ([74.207.234.97]:59236 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaBRBoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:44:01 -0500
Date: Mon, 17 Feb 2014 20:43:54 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH] ext4: address a benign compiler warning
Message-ID: <20140218014354.GE26580@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Patrick Palka <patrick@parcs.ath.cx>, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	joe@perches.com
References: <CA+C-WL9ARNvOqeA4n5Abnja+99O4F1VdMDUPjuRCcXiVsMTc7A@mail.gmail.com>
 <1392264724-10542-1-git-send-email-patrick@parcs.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392264724-10542-1-git-send-email-patrick@parcs.ath.cx>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:12:04PM -0500, Patrick Palka wrote:
> When !defined(CONFIG_EXT4_DEBUG), mb_debug() should be defined as a
> no_printk() statement instead of an empty statement in order to suppress
> the following compiler warning:
> 
> fs/ext4/mballoc.c: In function ‘ext4_mb_cleanup_pa’:
> fs/ext4/mballoc.c:2659:47: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
>    mb_debug(1, "mballoc: %u PAs left\n", count);
> 
> Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>

Thanks, applied.

					- Ted
