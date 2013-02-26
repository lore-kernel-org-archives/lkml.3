Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170Ab3BZXPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:15:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34468 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab3BZXPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:15:44 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-90-512d421e19d8
Date: Tue, 26 Feb 2013 23:15:42 +0000 (GMT)
From: =?euc-kr?B?vNvAurrA?= <eunb.song@samsung.com>
Subject: Re: Re: I2C: Fix i2c fail problem when a process is terminated by a
 signal on octeon in 3.8
To: David Daney <ddaney@caviumnetworks.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130226231059558@eunb.song
Msgkey: 20130226231059558@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130226231059558@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <13700407.150151361920541315.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zjq6ck26gwe2d/BaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj5rv/TAXLxCr+Nb1mamC8IdrFyMkhJKAi0fL/OyOILSFgItHz
	9jUbhC0mceHeeiCbC6hmGaPE8Z+N7DBFN1+eYIRIzGeUmL/sLVg3i4CqxPQVb1lAbDagog0/
	JoA1CAukSOxeuZEVxBYR0JVoed8GVs8sUCPx6s8VFogr5CUmn74MVs8rIChxcuYTFohlShI7
	t7xjgYgrS+xpnwJ1nYTErOkXWCFsXokZ7U+h6uUkpn1dwwxhS0ucn7WBEeabxd8fQ8X5JY7d
	3sHUxcgB1vvkfjDMmN2bv0CNF5CYeuYgI0SJukTPPR6IMJ/EmoVvWWCm7Dq1nBmm9f6WuUwQ
	XylKTOl+yA5ha0l8+bGPDd1XvAJOEi9fv2KfwKg8C0lqFpL2WUjakdUsYGRZxSiaWpBcUJyU
	XmSqV5yYW1yal66XnJ+7iRGSFibuYLx/wPoQYzIwRiYyS4km5wPTSl5JvKGxgbGhoaWhmaml
	qQFpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MG561OI2YfmDrbda5B94KP9s
	EXHO65r9Nm7r4/N28RKZPUd/BnB5xzWG3PyfZqjYbZpmNPfJYwE/fus3mTFODBJhemsv7vln
	Hmn47qVlxGLHqmsdCb0xSqz5F4Wmcomt9DklmXtj+tqMF8y87bwneE0FFSbbm3DeCpux4IE8
	v+PPZRu9Ql9UKLEUZyQaajEXFScCAMcnhu4hAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DF05J91Ag8/zuSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xs13/5kKlolV/Gt6zdTAeEO0i5GTQ0hARaLl/3dGEFtCwETi5ssTULaYxIV769m6GLmAauYz
	Ssxf9hYswSKgKjF9xVsWEJsNqGHDjwnsILawQIrE7pUbWUFsEQFdiZb3bWD1zAI1Eq/+XGGB
	WCYvMfn0ZbB6XgFBiZMzn7BALFOS2LnlHQtEXFliT/sUNoi4hMSs6RdYIWxeiRntT6Hq5SSm
	fV3DDGFLS5yftQHu6MXfH0PF+SWO3d7B1MXIAdb75H4wzJjdm79AjReQmHrmICNEibpEzz0e
	iDCfxJqFb1lgpuw6tZwZpvX+lrlMEF8pSkzpfsgOYWtJfPmxjw3dV7wCThIvX79in8AoNwtJ
	ahaS9llI2pHVLGBkWcUomlqQXFCclF5hqFecmFtcmpeul5yfu4kRnKCeLdzB+OW89SFGAQ5G
	JR7eBZd0AoVYE8uKK3MPMUpwMCuJ8H48ABTiTUmsrEotyo8vKs1JLT7EmAyMv4nMUqLJ+cDk
	mVcSb2hsYGxoaGluYGpoZEGasJI473Fz9UAhgfTEktTs1NSC1CKYLUwcnFINjOIrr5X0r7H2
	PhXRarF4mpj2tuT78ycy56Tvf22afmtzjsGb31niP5bd/M/2YtWDutirVlV74+z+Xf5nsWri
	v9UrjiX80dh1JWvvbg/Rg1riKs/ZeXWy246+/7vT7ZbTmzyNafd3G2rNPsA0qbHd8NKrG2sU
	P4ik3f4Vd099eVdlvtrF2w+3FXgrsRRnJBpqMRcVJwIA6QMsh5QDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1QNFl4U001685


>If the wait is not interruptible, I think you will not be able to 'kill
>-9' a userspace process blocked here.

As your words. the process will not be killed immediately, but after timeout(2 jiffies) it will be killed.
I think that delay is acceptable. 


------- Original Message -------
Sender : David Daney<ddaney@caviumnetworks.com>
Date : 2013-02-27 08:07 (GMT+09:00)
Title : Re: I2C: Fix i2c fail problem when a process is terminated by a signal on octeon in 3.8

On 02/26/2013 12:54 PM, º€¿∫∫¿ wrote:
> I've been debugging the abnormal operation of i2c on octeon.
> If a process is terminated by signal in the middle of i2c operation,
> next i2c read operation which is done by another process was failed.
> So i changed to ignore signal in the middle of i2c operation.
> After that the problem was not reproduced.
> 

This is a known issue.  However I don't think the solution you have is
correct...

> Signed-off-by: EunBong Song > >
> 
> diff -up drivers/i2c/busses/i2c-octeon.c{.orig,}
> --- drivers/i2c/busses/i2c-octeon.c.orig 2013-02-21 08:09:03.168018843 -0800
> +++ drivers/i2c/busses/i2c-octeon.c 2013-02-21 08:09:38.344018898 -0800
> @@ -183,7 +183,7 @@ static irqreturn_t octeon_i2c_isr(int ir
>    struct octeon_i2c *i2c = dev_id;
> 
>    octeon_i2c_int_disable(i2c);
> - wake_up_interruptible(&i2c->queue);
> + wake_up(&i2c->queue);
> 
>    return IRQ_HANDLED;
>   }
> @@ -206,7 +206,7 @@ static int octeon_i2c_wait(struct octeon
> 
>    octeon_i2c_int_enable(i2c);
> 
> - result = wait_event_interruptible_timeout(i2c->queue,
> + result = wait_event_timeout(i2c->queue,

If the wait is not interruptible, I think you will not be able to 'kill
-9' a userspace process blocked here.

>           octeon_i2c_test_iflg(i2c),
>           i2c->adap.timeout);
> 

The real solution is to move processing of the I2C protocol to a kernel
thread and communicate between the this thread and userspace via a
command queue mechanism, much like the way it is done in the mmc/host
driver infrastructure.

David DaneyˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
