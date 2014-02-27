Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaB0B7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:59:45 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:58656 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbaB0B7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:59:42 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2014 20:59:41 EST
X-Original-SENDERIP: 10.185.110.87
X-Original-MAILFROM: chanho.min@lge.com
X-AuditID: 9c930173-b7f9b6d000006d39-d9-530c4a506789
Subject: Re : [PATCH 4/8] lib: Add prototype declarations in lib/clz_ctz.c
References: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
In-Reply-To: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRWlGSWpSXmKPExsVyMfSOpm6gF0+wwfTZlhYfr11gd2D06Hp7
	hSmAMYrLJiU1J7MstUjfLoErY93JiILPfBWz+x4zNTAu4eli5OSQEDCRmPllERuELSZx4d56
	MFtIYAejxIMZqV2MXEB2L6PEnZf72UESLAK3WSUanytDNFRKNDbcZOxi5AAqUpd4s94Aor6H
	SeL9klvMEPWqEv97j4H1sgnoS3ycdpgVxBYRUJDY3PuMFaSBWWAKo8SGKV1MIAlhAVeJixOe
	soDYvAJxEsd3ToRaECfR/CUMIiwocXLmE7ASZqC9f+ZdYgYpYRaQllj+jwMiLC/RvHU22Amc
	AvESv1/+B/tLVEBFYsrJbWwTGEVnIZk0C8mkWQiTZiGZtICRZRWjsI+7q6NvkKuPp4GpXk56
	ql5yfu4mRmAkzJnMWLyD8cRUm0OMAhyMSjy8ncXcwUKsiWXFlbmHGCU5mJREef858gQL8SXl
	p1RmJBZnxBeV5qQWH2KU4GBWEuHl9ADK8aYkVlalFuXDpKQ5WJTEedekegUJCaQnlqRmp6YW
	pBbBZJk42A8xynBwKEnwKnoCdQsWpaanVqRl5pQgq+EE2cADtMEYpIa3uCAxtzgzHSJ/itGY
	Y/KGn58YOY4f/fOJUYglLz8vVUqc194dqFQApDSjNA9uGiytXWKUlRLmZWRgYBDiATonN7ME
	Vf4VozgwBIR5TUEW8mTmlcDtewV0ChPQKUelwU4pSURISTUwmopKr0zXOGLs5Kt2+y7Xmoul
	mU7KT8r9Htn99vpyW+jWOn3ebTsTpxow+5TNX8fH9i8hbM+8FHPPVZwXHzJ1t+sssrKTKpd8
	KGL3LvlJCYdmh6JjaGeq8MYqR7MffPe3N1TdjF87/VnewdCzdxbwpCkdcjnn4tdxW6K0295t
	1u+t2+/quv5RYinOSDTUYi4qTgQAinI/U2YDAAA=
MIME-Version: 1.0
Reply-To: "=?EUC-KR?B?uc7C+cij?=" <chanho.min@lge.com>
X-Priority: 3 (Normal)
Auto-Submitted: auto-generated
From: "=?EUC-KR?B?uc7C+cij?=" <chanho.min@lge.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Message-ID: <OFFE1CC7B6.1A38C928-ON49257C8C.00099492-49257C8C.00099493@lge.com>
Date: Thu, 27 Feb 2014 10:44:38 +0900
X-MIMETrack: Serialize by Router on LGEKRHQMS17A/LGE/LG Group(Release 8.5.3FP3HF583 | August
 9, 2013) at 2014/02/27 10:44:39
Content-type: text/plain; charset=EUC-KR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1R1xmqT003458


> -----Original Message-----
> From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
> Sent: Tuesday, February 25, 2014 4:46 PM
> To: linux-kernel@vger.kernel.org
> Cc: Andrew Morton; Rashika Kheria; Chanho Min; josh@joshtriplett.org
> Subject: [PATCH 4/8] lib: Add prototype declarations in lib/clz_ctz.c
>
> Add prototype declarations of functions in lib/clz_ctz.c. These
> functions are required by GCC builtins and hence can not be removed
> despite of their unreferenced appearance in kernel source.
>
> This eliminates the following warning in lib/clz_ctz.c:
> lib/clz_ctz.c:16:12: warning: no previous prototype for °Æ__ctzsi2°Ø [-Wmissing-prototypes]
> lib/clz_ctz.c:22:12: warning: no previous prototype for °Æ__clzsi2°Ø [-Wmissing-prototypes]
> lib/clz_ctz.c:44:12: warning: no previous prototype for °Æ__clzdi2°Ø [-Wmissing-prototypes]
> lib/clz_ctz.c:50:12: warning: no previous prototype for °Æ__ctzdi2°Ø [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Chanho Min <chanho.min@lge.com>ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
