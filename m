Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbaKTQOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:14:40 -0500
Received: from imap.thunk.org ([74.207.234.97]:41827 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbaKTQOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:14:38 -0500
Date: Thu, 20 Nov 2014 11:14:36 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ext4: kill ext4_kvfree()
Message-ID: <20141120161436.GC7112@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20141120081004.GH7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120081004.GH7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very cool that kvfree() appeared in 3.15; thanks, for adding it to
mm/util.c!  I hadn't noticed when it went in, or I would have dropped
ext4_kvfree() earlier.

Thanks, applied to the ext4 tree.

						- Ted
