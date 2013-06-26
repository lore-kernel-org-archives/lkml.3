Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3FZTQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:16:40 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37917 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752050Ab3FZTQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:16:39 -0400
Date: Wed, 26 Jun 2013 14:16:35 -0500
From: Ben Myers <bpm@sgi.com>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for May 2013
Message-ID: <20130626191635.GT32736@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May saw the merge of the XFS development tree for Linux 3.10 into
mainline as well as a number of fixes after the initial merge.

Linux 3.10 will be an exciting release for XFS as this release includes
an experimental feature, CRC protection for on-disk metadata structures.
In order to create a CRC enabled filesystem, build the crc-dev branch of
xfsprogs located at git://oss.sgi.com/xfs/cmds/xfsprogs.git and mkfs.

We also saw the release of xfsprogs-3.1.11 and xfsdump-3.1.3.  xfsprogs
includes a numerous fixes for xfs_repair, xfs_metadump, mkfs, and
xfs_db.  xfsdump has fixes for a backward compatability problem with
dumps created with 3.1.2, and a fix for a segfault in xfsrestore.

Other work that was posted in May includes a series of fixes for log
space validation, a revision of a patchset to allow project and group
quotas to be used simultaneously, and a number of new tests for
xfstests.
