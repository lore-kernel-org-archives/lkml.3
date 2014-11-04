Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaKDK3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:29:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaKDK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:27:58 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
Date: Tue,  4 Nov 2014 11:27:27 +0100
Message-Id: <1415096851-17209-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  this patch set removes use of i_devices from block and character device
code and thus we can remove the list head from struct inode thus saving two
pointers in it. As Christoph has reviewed the series, can you please merge
it Al? Thanks!

Since v2 I've added reviewed-by tags from Christoph and changed one variable
name in cdev_forget().

Since v1 I have split the patches and properly handled character devices (I
broke them last time as Christoph pointed out).

								Honza
