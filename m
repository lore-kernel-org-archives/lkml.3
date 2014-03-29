Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaC2KW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 06:22:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62659 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaC2KW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 06:22:56 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-e3-53369eff8e5f
Date: Sat, 29 Mar 2014 10:22:55 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: latest 3.14.0-rc8+ : "INFO: inconsistent lock state "
To: Cong Wang <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20140329101501411@jongman.heo
Msgkey: 20140329101501411@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140329101501411@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <9572737.16301396088574413.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSoPt/nlmwwaqVnBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjxrsTTAVvpCv6Zh1lamDske5i5OQQElCTuPn5ECOILSFgIrFk
	62UWCFtM4sK99WxdjFxANUsZJU7PmA5XdGf2MWaIxHxGia73V5lBEiwCqhIT226DFbEJ6Eh0
	/N/PCmILC7hJzP2yH2gSB4eIQLDE+nvuIGFmAXOJ+bNOMEMcoShxbeliNhCbV0BQ4uTMJ1BH
	qEjsWdnGChFXlWj9e5AVIi4hMWv6BSibV2JG+1OoejmJaV/XMEPY0hLnZ21ghHlm8ffHUHF+
	iWO3dzCBnAPS++R+MMyY3Zu/sEHYAhJTzxyEatWU6Fv5kh3C5pNYs/AtC8yYXaeWM8P03t8y
	lwniLUWJKd0P2SFsLYkvP/ZheItXwEHi//d3jBMYlWchSc1C0j4LSTuymgWMLKsYRVMLkguK
	k9KLDPWKE3OLS/PS9ZLzczcxAtPC6X/Pencw3j5gfYgxGRgjE5mlRJPzgWklryTe0NjMyMLU
	xNTYyNzSjDRhJXHepIdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYa5oy2V+npKy7P734
	/tGj2y0SDxy7X/1/ol5g94X3cnFmG23Zva7J8bxoiDoTd5hL/LsW19tq/2szl3gwnNnGeab6
	Yc0DjgcL57mpTU3zl2WZFmq2LZvjnPSZrYxijctmhEy9+nviZG6+d+dnuS9KyhM2viB7l1G1
	4ZrEMoej/z485Q1utHh4TYmlOCPRUIu5qDgRALwNCB8hAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/t6br/55kFG5y5xWhxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jJm
	vDvBVPBGuqJv1lGmBsYe6S5GTg4hATWJm58PMYLYEgImEndmH2OGsMUkLtxbz9bFyAVUM59R
	ouv9VbAEi4CqxMS222ANbAI6Eh3/97OC2MICbhJzv+wHauDgEBEIllh/zx0kzCxgLjF/1glm
	iF2KEteWLmYDsXkFBCVOznzCArFLRWLPyjZWiLiqROvfg6wQcQmJWdMvQNm8EjPan0LVy0lM
	+7oG6k5pifOzNjDC3Lz4+2OoOL/Esds7mEDOAel9cj8YZszuzV/YIGwBialnDkK1akr0rXzJ
	DmHzSaxZ+JYFZsyuU8uZYXrvb5nLBPGWosSU7ofsELaWxJcf+zC8xSvgIPH/+zvGCYxys5Ck
	ZiFpn4WkHVnNAkaWVYyiqQXJBcVJ6RWGesWJucWleel6yfm5mxjByenZwh2MX85bH2IU4GBU
	4uHNaDcNFmJNLCuuzD3EKMHBrCTCGzTZLFiINyWxsiq1KD++qDQntfgQYzIw/iYyS4km5wMT
	Z15JvKGxsYmZiamliYWBqTlpwkrivHdvJgUJCaQnlqRmp6YWpBbBbGHi4JRqYLSq5LhR3p5x
	5NhJyeTXP/pNZnAvWt+4YK+MSkfNv3qdqxufLONXEZnYl9Juqhp79cX+p3vM8vaf6Yy5e/OI
	UNX6NTNqRRo0H66cXMqt63jmXMBW813Wf7WEHrozrTBsWKN0aN/DwGWRL+boHfB8neH/Xros
	6eHUX0q3GAIfRjiEC1x+YM+W8lWJpTgj0VCLuag4EQBV0/IkkgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2TANJRX017424


>
>
>------- Original Message -------
>
>Sender : Cong Wang<xiyou.wangcong@gmail.com>
>
>Date : 2014-03-29 13:23 (GMT+09:00)
>
>Title : Re: latest 3.14.0-rc8+ : "INFO: inconsistent lock state "
>
>
>
>On Fri, Mar 28, 2014 at 8:21 PM, Jongman Heo wrote:
>>
>> Hi, guys,
>>
>> With today's linus git tree, I got following messages;
>>
>> [   97.426196] =================================
>> [   97.426198] [ INFO: inconsistent lock state ]
>> [   97.426221] 3.14.0-rc8+ #45 Tainted: G        W
>> [   97.426224] ---------------------------------
>> [   97.426227] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
>> [   97.426229] kworker/7:1/101 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> [   97.426231]  (&addrconf_stats->syncp.seq){+.?...}, at: [] mld_send_initial_cr.part.30+0x81/0xa0
>> [   97.426255] {IN-SOFTIRQ-W} state was registered at:
>> [   97.426258]   [] __lock_acquire+0x414/0x18e0
>> [   97.426265]   [] lock_acquire+0x98/0x120
>> [   97.426268]   [] mld_sendpack+0xdf/0x5b0
>> [   97.426270]   [] mld_ifc_timer_expire+0x191/0x2c0
>> [   97.426272]   [] call_timer_fn+0x75/0x160
>> [   97.426276]   [] run_timer_softirq+0x192/0x230
>> [   97.426281]   [] __do_softirq+0xfb/0x2b0
>> [   97.426286] irq event stamp: 33365
>> [   97.426289] hardirqs last  enabled at (33365): [] __local_bh_enable_ip+0x6b/0xc0
>> [   97.426292] hardirqs last disabled at (33363): [] __do_softirq+0x145/0x2b0
>> [   97.426294] softirqs last  enabled at (33364): [] __do_softirq+0x1a4/0x2b0
>> [   97.426297] softirqs last disabled at (33341): [] do_softirq_own_stack+0x35/0x40
>> [   97.426303]
>> other info that might help us debug this:
>> [   97.426305]  Possible unsafe locking scenario:
>>
>> [   97.426306]        CPU0
>> [   97.426307]        ----
>> [   97.426308]   lock(&addrconf_stats->syncp.seq);
>> [   97.426310]   
>> [   97.426311]     lock(&addrconf_stats->syncp.seq);
>> [   97.426313]
>>  *** DEADLOCK ***
>
>Does the following patch help?
>
>diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
>index e1e4735..74a774a 100644
>--- a/net/ipv6/mcast.c
>+++ b/net/ipv6/mcast.c
>@@ -1588,7 +1588,7 @@ static void mld_sendpack(struct sk_buff *skb)
>
>        rcu_read_lock();
>        idev = __in6_dev_get(skb->dev);
>-       IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
>+       IP6_UPD_PO_STATS_BH(net, idev, IPSTATS_MIB_OUT, skb->len);
>
>        payload_len = (skb_tail_pointer(skb) - skb_network_header(skb)) -
>                sizeof(*pip6);
>
>
>

Hi,

No, it doesn't fix the issue.

Regards,
Jongman Heo.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
