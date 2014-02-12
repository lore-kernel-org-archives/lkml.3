Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaBLRgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:36:12 -0500
Received: from imap.thunk.org ([74.207.234.97]:57147 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbaBLRgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:36:10 -0500
Date: Wed, 12 Feb 2014 12:36:07 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 11/21] fs: Mark functions as static in jbd2/journal.c
Message-ID: <20140212173607.GH14520@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Rashika Kheria <rashika.kheria@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	josh@joshtriplett.org
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 06:41:21PM +0530, Rashika Kheria wrote:
> Mark functions as static in jbd2/journal.c because they are not used
> outside this file.
> 
> This eliminates the following warning in jbd2/journal.c:
> fs/jbd2/journal.c:125:5: warning: no previous prototype for ‘jbd2_verify_csum_type’ [-Wmissing-prototypes]
> fs/jbd2/journal.c:146:5: warning: no previous prototype for ‘jbd2_superblock_csum_verify’ [-Wmissing-prototypes]
> fs/jbd2/journal.c:154:6: warning: no previous prototype for ‘jbd2_superblock_csum_set’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thanks, applied to the ext4 tree.

					- Ted
