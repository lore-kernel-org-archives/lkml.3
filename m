Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3GBFpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:45:11 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64673 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3GBFpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:45:09 -0400
Date: Tue, 2 Jul 2013 13:45:04 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 0/3]  implement of updating atime for client has CEPH_CAP_FILE_RD
X-Priority: 3
X-GUID: 3470A365-ECE0-4A6F-9513-E3F65CF533E2
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307021345012243134@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r625jOJX005628

Now update atime of file, only for client had CEPH_CAP_FLE_EXCL.But for atime, if one can read he can update this attribte.
For this feature,it need both client and mds modify.
PATCH1,it modify the mds to support.
PATCH2,it modify the client to suport.
PATCH3, it support this feature for sync_read mode.

Jianpeng Ma (3):
 mds: update atime if client can read
  ceph: update atime after read-operation.
  ceph: For ceph_sync_read, update the atime of file.

 fs/ceph/file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

-- 
1.8.1.2ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
