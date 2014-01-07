Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaAGNAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:00:34 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:64753 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbaAGNAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:00:25 -0500
Message-ID: <1389099622.15032.18.camel@x41>
Subject: [PATCH 0/2] net/mlx4_core: clean up two functions
From: Paul Bolle <pebolle@tiscali.nl>
To: Or Gerlitz <ogerlitz@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Rony Efraim <ronye@mellanox.com>, Hadar Hen Zion <hadarh@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jan 2014 14:00:22 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jan 2014 13:00:23.0768 (UTC) FILETIME=[6D913D80:01CF0BA8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) These two patches are very similar. They both clean up a function to
help GCC understand the codeflow. Both help silence a warning.

1) Compile tested only (on 32 bits x86). I do not have this hardware.

2) Please note that there's no MAINTAINERS entry for mlx4_core. (Neither
is there an entry for the MLX4 IB driver.) Shouldn't it be added? 

Paul Bolle (2):
  net/mlx4_core: clean up cq_res_start_move_to()
  net/mlx4_core: clean up srq_res_start_move_to()

 .../net/ethernet/mellanox/mlx4/resource_tracker.c  | 96 ++++++++--------------
 1 file changed, 35 insertions(+), 61 deletions(-)

-- 
1.8.4.2

