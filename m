Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3LSK2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:28:23 -0500
Received: from m13-110.163.com ([220.181.13.110]:45993 "EHLO m13-110.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3LSK2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:28:21 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 05:28:20 EST
X-Originating-IP: [166.111.131.12]
Date: Thu, 19 Dec 2013 18:12:40 +0800 (CST)
From: xiaoqixue_1 <xiaoqixue_1@163.com>
To: "Greg KH" <gregkh@linuxfoundation.org>
Cc: xqx12 <s2exqx@gmail.com>, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        chyyuu@gmail.com, xuyongjiande@gmail.com
Subject: Re:Re: [PATCH] tty: an overflow of multiplication in
 drivers/tty/cyclades.c
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20131204(24406.5820.5783) Copyright (c) 2002-2013 www.mailtech.cn 163com
In-Reply-To: <20131219005740.GA6257@kroah.com>
References: <1387328429-15172-1-git-send-email-xiaoqixue_1@163.com>
 <20131219005740.GA6257@kroah.com>
Content-Type: text/plain; charset=us-ascii
MIME-Version: 1.0
Message-ID: <22cc7e30.8cb3.1430a57c434.Coremail.xiaoqixue_1@163.com>
X-CM-TRANSID: bsGowEBZK0KZxrJS9NsKAA--.6173W
X-CM-SenderInfo: 50ld015l0xvsqr6rljoofrz/1tbivwD4vVD+QtE-yQABsw
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJF5MGL004176

I am sorry for it because my git configure is not sound.

my real name Qixue Xiao , and my email  &lt;xiaoqixue_1@163.com&gt;.
At 2013-12-19 08:57:40,"Greg KH" <gregkh@linuxfoundation.org> wrote:
>On Wed, Dec 18, 2013 at 09:00:29AM +0800, xqx12 wrote:
>> there is an overflow in the code :
>> cyz_polling_cycle = (arg * HZ) / 1000,
>> the multiplicator arg comes from user, so it may be an overflow if
>> arg is a big number. And the value of cyc_polling_cycle will be
>> wrong when it is used next time.
>> 
>> Reported-by: Qixue Xiao <xiaoqixue_1@163.com>
>> Suggested-by: Yongjian Xu <xuyongjiande@gmail.com>
>> Suggested-by: Yu Chen <chyyuu@gmail.com>
>> Signed-off-by: Qixue Xiao <xiaoqixue_1@163.com>
>
>I need a "real" name as the "From:" line here, especially as it doesn't
>match any of these lines either :(
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
