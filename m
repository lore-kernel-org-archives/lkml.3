Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3KNFPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 00:15:03 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:54700 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082Ab3KNFPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 00:15:01 -0500
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org
Cc: minchan@kernel.org, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 0/4] Squashfs: performance improvement patches (V3)
Date: Thu, 14 Nov 2013 05:14:15 +0000
Message-Id: <1384406059-28567-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a partial patchset of V3 patches following review by myself
and others.  Changes are described in the individual patches.

There is one additional patch which fixes a static checker error.

Squashfs: Refactor decompressor interface and code (V3)
Squashfs: Generalise paging handling in the decompressors (V3)
Squashfs: Directly decompress into the page cache for file data (V3)
Squashfs: Check stream is not NULL in decompressor_multi.c
