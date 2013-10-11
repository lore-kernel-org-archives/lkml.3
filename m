Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab3JKURi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:17:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab3JKTk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@fedoraproject.org>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 008/135] tcp: Add missing braces to do_tcp_setsockopt
Date: Fri, 11 Oct 2013 12:38:09 -0700
Message-Id: <20131011193946.116674220@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

[ Upstream commit e2e5c4c07caf810d7849658dca42f598b3938e21 ]

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2454,10 +2454,11 @@ static int do_tcp_setsockopt(struct sock
 	case TCP_THIN_DUPACK:
 		if (val < 0 || val > 1)
 			err = -EINVAL;
-		else
+		else {
 			tp->thin_dupack = val;
 			if (tp->thin_dupack)
 				tcp_disable_early_retrans(tp);
+		}
 		break;
 
 	case TCP_REPAIR:


