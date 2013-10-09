Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3JIOkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:40:23 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60861 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3JIOkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:40:22 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 0/5] fat: additions to support fat_fallocate
Date: Wed,  9 Oct 2013 23:40:15 +0900
Message-Id: <1381329615-11803-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch set provides support for doing fallocate operation on FAT filesystem.
After series of review for the the feature
The complete functionality is broken down into smaller subsets.

Namjae Jeon (5):
 fat: add i_disksize to represent uninitialized size
 fat: add fat_fallocate operation
 fat: zero out seek range on _fat_get_block
 fat: fallback to buffered write in case of fallocatded region on direct IO
 fat: permit to return phy block number by fibmap in fallocated region
-- 
1.7.9.5

