Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaJSEhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 00:37:52 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:43289 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaJSEhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 00:37:48 -0400
Message-ID: <54434016.2070209@roeck-us.net>
Date: Sat, 18 Oct 2014 21:37:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Upstream kernel build failures in include/net/tcp.h
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.5443401B.00BA,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting lots of build failures with the latest upstream kernel.

In file included from net/core/sock.c:140:0:
include/net/tcp.h: In function 'tcp_v6_iif':
include/net/tcp.h:738:32: error: 'union <anonymous>' has no member named 'h6'

This may have been introduced by 870c3151382 ("ipv6: introduce tcp_v6_iif()").
 From the context, it looks like it happens if CONFIG_IPV6 is not enabled.

For details and failed configurations see the 'master' column at
http://server.roeck-us.net:8010/builders.

Guenter
