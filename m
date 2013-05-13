Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3EMATs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 20:19:48 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:56591 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3EMATr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 20:19:47 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 08:19:46 +0800
Message-ID: <CAAJw_Zv4Cy-fSg24F=7poRNs2oGA=7nuZQtQOyf_-dsStzNpgw@mail.gmail.com>
Subject: linux-3.10-rc1 procfs interface breaks vmware, eicon, fio .... any fix?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone on lkml working on patches for vmware to make it run on
Linux-3.10-rc1? The recent change in procfs interface breaks vmware,
diva/eicon and fio modules.

Every modules is now broken and needs to be reworked. Is there a more
subtle way to handle this like give more time to allow developers to
handle the move rather than killing off the "tranditional" procfs
access ... like a warning that the interface is going away soon?


Thanks,
Jeff
