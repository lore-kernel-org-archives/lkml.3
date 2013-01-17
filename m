Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3AQFJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:09:51 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50921 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714Ab3AQFJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:09:48 -0500
X-Sasl-enc: G74wyTMWKIWDhUlWYwOK1Duz4u/Ls+BOYdbHxfmB09DH 1358399387
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Cheneau <tony.cheneau@amnesiak.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 0/2] Handle Uncompressed IPv6 on 6LoWPAN
Date: Thu, 17 Jan 2013 00:09:46 -0500
Message-Id: <1358399388-30062-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1358315037-10043-1-git-send-email-alan@signal11.us>
References: <1358315037-10043-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been tested by exchanging data with with the Contiki operating
system using a Redwire Econotag.  Contiki had to be set to send uncompressed
data, and had to have a #define modified to enable reception and processing
of header-compressed packets when not set to send compressed data.

Version 2 fixes a format issue pointed out by David Miller.

Alan Ott (2):
  6lowpan: Refactor packet delivery into a function
  6lowpan: Handle uncompressed IPv6 packets over 6LoWPAN

 net/ieee802154/6lowpan.c | 79 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 23 deletions(-)

-- 
1.7.11.2

