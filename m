Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191Ab3DJKQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:16:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19705 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3DJKQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:16:46 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-bc-51653c0c9fea
Date: Wed, 10 Apr 2013 10:16:44 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] staging: Enhance cpu load-balance octeon ethernet driver
To: david.daney@cavium.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130410100350345@eunb.song
Msgkey: 20130410100350345@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130410100350345@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <3910056.318101365589004261.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zri6PTWqgweED5haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjT+MypoJbvBVLn29ia2BcwdvFyMkhJKAi0fL/OyOILSFgItG8
	aDszhC0mceHeerYuRi6gmmWMEjNmfGeBKTq37BUzRGI+o8TKhrdsIAkWAVWJvbtXgxWxCWhL
	vP3ygLWLkYNDWMBL4skMDpCwiIC8xJonz9lBbGYBD4ntmzcyQhwhLzH59GWwOK+AoMTJmU+g
	dilJTLjawQgRV5ZoPfURKi4hMWv6BVYIm1diRvtTqLicxLSva6AekJY4P2sDI8wzi78/horz
	Sxy7vYMJ5DSQ3if3g2HG7N78hQ3CFpCYeuYgVKu6RO+mJnYIm09izcK3LDBjdp1azgzTe3/L
	XCaItxQlpnQ/hHpRS+LLj31s6N7iFXCU2LD9FcsERuVZSFKzkLTPQtKOrGYBI8sqRtHUguSC
	4qT0IlO94sTc4tK8dL3k/NxNjJC0MHEH4/0D1ocYk4ExMpFZSjQ5H5hW8kriDY3NjCxMTUyN
	jcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuH/xbD++3q0JK6PqXJ69
	63KWfLheOeNVbJN5lFzJh4wP0XzcO5yaf05hk1uptZ3t2i8NluTuW1v/Ha57xvi0TGue9K+a
	qSohp5afffPJ82P0V5F0fT+FTeKxW85yal54c8Ldfv+qltodW1xm3WLJqXORV5EokhNVn2C9
	d/q7un6rp0leU5m2K7EUZyQaajEXFScCAE1zySIhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DF0em9RAg9nfTSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xp/GZUwFt3grlj7fxNbAuIK3i5GTQ0hARaLl/3dGEFtCwETi3LJXzBC2mMSFe+vZuhi5gGrm
	M0qsbHjLBpJgEVCV2Lt7NQuIzSagLfH2ywPWLkYODmEBL4knMzhAwiIC8hJrnjxnB7GZBTwk
	tm/eyAixS15i8unLYHFeAUGJkzOfsEDsUpKYcLWDESKuLNF66iNUXEJi1vQLrBA2r8SM9qdQ
	cTmJaV/XQN0pLXF+1gZGmJsXf38MFeeXOHZ7BxPIaSC9T+4Hw4zZvfkLG4QtIDH1zEGoVnWJ
	3k1N7BA2n8SahW9ZYMbsOrWcGab3/pa5TBBvKUpM6X4I9aKWxJcf+9jQvcUr4CixYfsrlgmM
	crOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXFSekVhnrFibnFpXnpesn5uZsYwQnq2cIdjF/OWx9i
	FOBgVOLhXWiYEijEmlhWXJl7iFGCg1lJhNdCKzVQiDclsbIqtSg/vqg0J7X4EGMyMP4mMkuJ
	JucDk2deSbyhsYGxoaGluYGpoZEFacJK4rxPW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDu3/fD
	wE/gzvkbt9kve9eub7zwvf3XT/WVfxUdEh7dEUv7XXL0r/sjs8KnETufzZ/8ZrVky/sfv2vr
	S87POvri+82YtheT5ghPT1OpEeRc7F3UerjvOPPR5e7fjTo2iG5cU2BROe+oxN1TE3bZbn95
	n3FO3v95C7O+75sW5OlcdKGJJZg/fMGu2UosxRmJhlrMRcWJAOy89omUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3AAGmjb011087


Currently, CPU for RX napi handler is scheduled when backlog packet count is greater than budget * cores_in_use.
If more cpus are used for RX napi handler, there is low possibility backlog packet count is greater than budget * cores_in_use.
This patch makes CPU for RX napi handler is scheduled when backlog packet count is greater than budget.
I tested with patch and the result is more cpu is scheduled in traffic congestion situation.

Signed-off-by: EunBong Song <eunb.song@samsung.com>
---
 drivers/staging/octeon/ethernet-rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 34afc16..13f9eae 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -300,7 +300,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
 			counts.u64 = cvmx_read_csr(CVMX_POW_WQ_INT_CNTX(pow_receive_group));
 			backlog = counts.s.iq_cnt + counts.s.ds_cnt;
-			if (backlog > budget * cores_in_use && napi != NULL)
+			if (backlog > budget && napi != NULL)
 				cvm_oct_enable_one_cpu();
 		}
 
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
