Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaCXXAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 19:00:15 -0400
Received: from imap.thunk.org ([74.207.234.97]:45480 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaCXXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 19:00:13 -0400
Date: Mon, 24 Mar 2014 19:00:00 -0400
From: tytso@mit.edu
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: acl: remove unneeded include of
 linux/capability.h
Message-ID: <20140324230000.GB13535@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jakub Sitnicki <jsitnicki@gmail.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1395645732-26569-1-git-send-email-jsitnicki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395645732-26569-1-git-send-email-jsitnicki@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 08:22:12AM +0100, Jakub Sitnicki wrote:
> acl.c has not been (directly) using the interface defined by
> linux/capability.h header since commit 3bd858ab1c451725c07a
> ("Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid
> check"). Remove it.
> 
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>

Thanks, applied.

					- Ted
