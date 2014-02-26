Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaBZBPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:15:22 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:44305 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaBZBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:15:20 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ben@decadent.org.uk, netdev@vger.kernel.org
Cc: f.fainelli@gmail.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 0/2] net: start kdoc'ifying net_device
Date: Tue, 25 Feb 2014 17:15:11 -0800
Message-Id: <1393377313-28695-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on extending some functionality I felt restricted
with the amount of documentation I can add. Part of this is that
the existing style on the header files don't let me be verbose.
This starts addressing that by using kdoc for the net_device
flags, and as Ben noted, the priv_flags can be moved out from
UAPI.

Luis R. Rodriguez (2):
  net: kdoc struct net_device flags and priv_flags
  net: move net_device priv_flags out from UAPI

 include/linux/netdevice.h |  83 ++++++++++++++++++++++++++++
 include/uapi/linux/if.h   | 134 +++++++++++++++++++++++++++-------------------
 2 files changed, 163 insertions(+), 54 deletions(-)

-- 
1.8.5.3

