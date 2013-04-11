Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211Ab3DKCDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:03:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24402 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3DKCDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:03:05 -0400
X-AuditID: cbfee68e-b7f946d000001e37-47-516619d71dba
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Steven Whitehouse'" <swhiteho@redhat.com>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] GFS2: return error if malloc failed in
 gfs2_rs_alloc()
Date: Thu, 11 Apr 2013 11:03:02 +0900
Message-id: <000501ce3658$b3022fd0$19068f70$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAtXBJYACaKDZQAAM/m2A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zY93rkmmBBp2LWC2WNHNbXN41h81i
	wcZHjBa/WpvZLXau62R3YPV4v+8qm0ffllWMHkvvHWX0+LxJLoAlissmJTUnsyy1SN8ugSvj
	3+pT7AXf2SsOTVvO0sB4jq2LkZNDQsBE4vCFxawQtpjEhXvrgeJcHEICyxglXs39zg5TtOT1
	T2aIxCJGicP3brFAOH8ZJZ5uOwRWxSagK3Fs/RawUSIC3hKnpvxiBrGZBcokzs25DRTnAGrg
	lljdHAQS5hTgkVj3pxOsRFggRGLn9P9gNouAqsTWO//BRvIK2Els37GLDcIWlPgx+R4LxEgt
	ifU7jzNB2PISm9e8ZQYZLyGgLvHory7EBX4S65dMgioRkdj34h0jyMkSAufYJf4tWw21S0Di
	2+RDLBC9shKbDjBD/CspcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRkV5x
	Ym5xaV66XnJ+7iZGSHT27WC8ecD6EGMy0PqJzFKiyfnA6M4riTc0NjOyMDUxNTYytzQjTVhJ
	nFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PN51+tezdM8Tc79K1g61+VRtVPh66F
	nF6St1bRz+biE8YjNe3T3v3dsf3pKZsdcjPyj547km8iL+Z6JUtwyZTpM5z41jQt2Lex40zs
	7dJPy7z7ijm3x682ZIswz83fMCusQ+l2jWjlTp4ueTHj6Q1Hqg9O+sN8S5rl5N6WS5oLz5RH
	/p/sliWvxFKckWioxVxUnAgAEcXpwOQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jAd3rkmmBBluuMFosaea2uLxrDpvF
	go2PGC1+tTazW+xc18nuwOrxft9VNo++LasYPZbeO8ro8XmTXABLVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QXiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxr/Vp9gLvrNXHJq2nKWB8RxbFyMnh4SAicSS1z+ZIWwx
	iQv31gPFuTiEBBYxShy+d4sFwvnLKPF02yF2kCo2AV2JY+u3sILYIgLeEqem/ALrZhYokzg3
	5zZQnAOogVtidXMQSJhTgEdi3Z9OsBJhgRCJndP/g9ksAqoSW+/8BxvJK2AnsX3HLjYIW1Di
	x+R7LBAjtSTW7zzOBGHLS2xe85YZZLyEgLrEo7+6EBf4SaxfMgmqRERi34t3jBMYhWYhmTQL
	yaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw7D+T2sG4ssHiEKMAB6MS
	D++JhtRAIdbEsuLK3EOMEhzMSiK8XDuBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTEt5
	JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4dGmPb5xI4rqV
	XuteXa/80nXUXvR+raDT2u9XIzsrlTPvnbpiFClqx8066+SctwvPvAub1zxd59Z2Xb5j3wU6
	Tyx40Du3YcH6za1vm7KZ2jpz1E4rTb41+fX8FVbOv2/tMcr4tfNDROOOw89nT1wTsDco75l2
	xdvbewySLYQXal622GkUcPWXoxJLcUaioRZzUXEiAJhf1HNBAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"

commit 441362d06be349430d06e37286adce4b90e6ce96 upstream

The error code in gfs2_rs_alloc() is set to ENOMEM when error
but never be used, instead, gfs2_rs_alloc() always return 0.
Fix to return 'error'.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 fs/gfs2/rgrp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b7eff07..9afba3d6 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -576,7 +576,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	RB_CLEAR_NODE(&ip->i_res->rs_node);
 out:
 	up_write(&ip->i_rw_mutex);
-	return 0;
+	return error;
 }
 
 static void dump_rs(struct seq_file *seq, const struct gfs2_blkreserv *rs)
-- 
1.7.9.5

