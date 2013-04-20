Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3DTHuS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 03:50:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39559 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3DTHuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 03:50:15 -0400
X-AuditID: cbfee68e-b7f946d000001e37-51-51724889dd6e
Date: Sat, 20 Apr 2013 07:49:29 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: Re: [PATCH]  I2C: Change the value of octeon i2c adapter
 timeout value
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130420074109857@eunb.song
Msgkey: 20130420074109857@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130420074109857@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11281802.80061366444168759.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zlm6nR1GgQccFa4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXxYccc9oIfPBUfZjg1MJ7g6WLk5BASUJFo+f+dEcSWEDCRmNfz
	mxnCFpO4cG89WxcjF1DNMkaJlq55LDBFy+ZMYodIzGeU2NXcBtbBIqAqcftiGzuIzSagLfH2
	ywNWEFtYIFxiyv6XYLaIgJrEodu9TCA2s0CNxOXt1xkhrpCXmHz6Mlgvr4CgxMmZT6CWKUms
	a9nPCBFXlpg+4TsTRFxCYtb0C6wQNq/EjPanUPVyEtO+roH6QFri/KwNjDDfLP7+GCrOL3Hs
	9g6gORxgvU/uB8OM2b35CxuELSAx9cxBqFZ1id5Ne6FsPok1C9+ywIzZdWo5M0zv/S1zod5S
	lJjS/ZAdwtaS+PJjHxu6t3gFHCW6JzxnnMCoPAtJahaS9llI2pHVLGBkWcUomlqQXFCclF5k
	pFecmFtcmpeul5yfu4kRkhb6djDePGB9iDEZGCUTmaVEk/OBaSWvJN7Q2MzIwtTE1NjI3NKM
	NGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxTjc347O7/PKsqNSO4W/pSnLhO
	uC/f3bsPI5l/sSk8qlU0C6l1ebfh7PUAob/bePM/Mrt3Pc4V2njj5JFjf9f/8dk4+eMj3daj
	k14x/0/I7r81QUGm3X75T7ZObesbu3ez1D/gUp0YqpwyM0vKTHORPBv/yay5GzZdnbvA7dCF
	qAylwtlPuiOUWIozEg21mIuKEwH+tpngIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DN1Oj6JAg/lPLCwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xocdc9gLfvBUfJjh1MB4gqeLkZNDSEBFouX/d0YQW0LARGLZnEnsELaYxIV769m6GLmAauYz
	SuxqbmMGSbAIqErcvtgGVsQmoC3x9ssDVhBbWCBcYsr+l2C2iICaxKHbvUwgNrNAjcTl7dcZ
	IZbJS0w+fRmsl1dAUOLkzCcsEMuUJNa17GeEiCtLTJ/wnQkiLiExa/oFVgibV2JG+1OoejmJ
	aV/XMEPY0hLnZ21ghDl68ffHUHF+iWO3dwDN4QDrfXI/GGbM7s1f2CBsAYmpZw5CtapL9G7a
	C2XzSaxZ+JYFZsyuU8uZYXrvb5kL9ZaixJTuh+wQtpbElx/72NC9xSvgKNE94TnjBEa5WUhS
	s5C0z0LSjqxmASPLKkbR1ILkguKk9AojveLE3OLSvHS95PzcTYzgBPVs0Q7Gf+etDzEKcDAq
	8fB6xBUGCrEmlhVX5h5ilOBgVhLhfWFbFCjEm5JYWZValB9fVJqTWnyIMRkYgROZpUST84HJ
	M68k3tDYwNjQ0NLcwNTQyII0YSVx3met1oFCAumJJanZqakFqUUwW5g4OKUaGA9fLlrB8SaW
	9ce/V47Nkvd2nC9ndnzWvCxkxxqNvB+yS5pZYxsnKO+xKl1ySP+nXtcey+yrv//U3es0cBHN
	O2A9VT/r/HU7XUnln9m204qqvpolHI++q+e5Xso2+FJfbOvW7LmvGlaE3thQlJg63917+pHj
	HztE2j2deCbdeP/u8r+EivW5JUosxRmJhlrMRcWJAEBLvL6UAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3K7oPVZ028824


> 
> Have you been writing to EEPROMS? Their erase/write cycle might be
> longer. But I am not forcing you to change the value, just giving some
> suggestions.

My board has i2c mux, temp sensor, eeprom.  And I added some debugging code for measuring i2c response time as below  and 
run i2c operation for each device. 
The maximum respeonse time was 500usec(under 1msec). So 20 msec is enough for adapter timeout. 
Thanks. 
static int octeon_i2c_wait(struct octeon_i2c *i2c)
{
        int result;
+        struct timeval start, end;

        octeon_i2c_int_enable(i2c);

+        do_gettimeofday(&start);
        result = wait_event_timeout(i2c->queue,
                                          octeon_i2c_test_iflg(i2c),
                                          i2c->adap.timeout);

+        do_gettimeofday(&end);

+        if(end.tv_usec < start.tv_usec){
+               end.tv_usec += 1000000;
+               end.tv_sec--;
+       }

+        if(result > 0)
+                printk("octeon_i2c_wait elapse time: %ld msecs\n", (end.tv_sec - start.tv_sec)*1000000 + (end.tv_usec - start.tv_usec));
+        else
+                printk("octeon_i2c_wait fail!!\n");
}ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
