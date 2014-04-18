Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaDRBXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:23:10 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42107 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaDRBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:23:07 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] 6lowpan: few changes to help with backports
Date: Thu, 17 Apr 2014 18:22:53 -0700
Message-Id: <1397784176-15809-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a few changes that can help automate the backport of 6lowpan.
I've been carrying them around for a while, I think its best to just
merge these upstream as its nothing controversial.

Luis R. Rodriguez (3):
  6lowpan: add helper to get 6lowpan namespace
  6lowpan: make lowpan_cb static
  6lowpan: include net/net_namespace.h on 6lowpan namepsace header

 include/net/6lowpan.h       |  1 +
 include/net/net_namespace.h | 15 ++++++++++++++
 net/ieee802154/reassembly.c | 48 +++++++++++++++++++++++++++++----------------
 3 files changed, 47 insertions(+), 17 deletions(-)

-- 
1.9.1

