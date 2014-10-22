Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbaJVUO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:14:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833AbaJVUOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:14:20 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v2] fs: Remove i_devices from struct inode
Date: Wed, 22 Oct 2014 22:14:09 +0200
Message-Id: <1414008853-13200-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  this patch set removes use of i_devices from block and character device
code and thus we can remove the list head from struct inode thus saving two
pointers in it.

Since v1 I have split the patches and properly handled character devices (I
broke them last time as Christoph pointed out).

								Honza
