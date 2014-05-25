Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaEYFEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 01:04:21 -0400
Received: from mout.web.de ([212.227.15.4]:50601 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaEYFDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 01:03:03 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCHv2 net-next 0/4] bridge: multicast snooping patches / exports
Date: Sun, 25 May 2014 07:03:21 +0200
Message-Id: <1400994205-31165-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.0.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:d6g9pP//DUWwwB+5OnEmb7BCqXWiTdVzXad+haCeoz22mIOkivL
 Oqxk4p3b4NwAV4bGwo3mfwlgbqMYE/Np3x4FeURIL7zDo4dud1roPkCcgmEW+14bRbZ82a/
 9Qxz9R02HbjMLDY6YOeWArokPAY7fdawxvCfNNwUEG6o4Irf0K3pH3yPTwdeNAemgZxl74Q
 trOP0tIWxeCPwpqHTW6ag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:

* fix a nasty typo in PATCH 1/4, br_multicast_update_query_timer():
  "br->multicast_query_interval" vs. "br->multicast_querier_interval"
  => this accidentally reduced the other querier present timer 
     from 255 to 125 seconds
* fix a typo in PATCH 2/4, br_ip{4,6}_multicast_query():
  ntohs(ETH_P_{IP,IPV6}) vs. htons(ETH_P_{IP,IPV6})
* add missing ntohl()s before address comparison in PATCH 2/4,
  br_ip4_multicast_select_querier() (thanks David!)

Cheers, Linus


