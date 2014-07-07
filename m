Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaGGOjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:39:10 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35142 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaGGOjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:39:08 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv2] btrfs compression: merge inflate and deflate z_streams
Date: Mon,  7 Jul 2014 23:38:28 +0900
Message-Id: <1404743909-17193-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.0.1.612.gea98109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
This patch reduces zlib compression memory usage by `merging' inflate
and deflate streams into a single stream.

-- v2: rebased-on linux-next rc4 20140707

Sergey Senozhatsky (1):
  btrfs compression: merge inflate and deflate z_streams

 fs/btrfs/zlib.c | 138 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 68 insertions(+), 70 deletions(-)

-- 
2.0.1.612.gea98109

