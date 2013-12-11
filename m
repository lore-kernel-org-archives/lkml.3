Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3LKOZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:25:35 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61926 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3LKOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:25:31 -0500
Message-ID: <52A875D9.6090609@mvista.com>
Date: Wed, 11 Dec 2013 08:25:29 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 2/5] a few open coded completions
References: <20131211003732.351606520@goodmis.org> <20131211003801.836995968@goodmis.org>
In-Reply-To: <20131211003801.836995968@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This chunk doesn't seem to belong in this patch...

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 819923f..ba78526 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1139,7 +1139,7 @@ struct net_device {
 	unsigned char		perm_addr[MAX_ADDR_LEN]; /* permanent hw address */
 	unsigned char		addr_assign_type; /* hw address assignment type */
 	unsigned char		addr_len;	/* hardware address length	*/
-	unsigned char		neigh_priv_len;
+	unsigned short		neigh_priv_len;
 	unsigned short          dev_id;		/* for shared network cards */
 
 	spinlock_t		addr_list_lock;

