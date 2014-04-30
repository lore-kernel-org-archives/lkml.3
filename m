Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945958AbaD3SIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:08:04 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:7225 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945910AbaD3SIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:08:01 -0400
From: "Bird, Tim" <Tim.Bird@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, "balbi@ti.com" <balbi@ti.com>
CC: Timothy Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Wed, 30 Apr 2014 20:07:05 +0200
Subject: Re: [PATCH v7 16/20] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
Thread-Topic: [PATCH v7 16/20] usb: phy: msm: Fix PTS definitions for MSM
 USB controller
Thread-Index: Ac9knx4tpi0Nl/j1TmaWmjgc8l8bTw==
Message-ID: <uukd0l7rkvba4wtolmxef0a4.1398881225694@email.android.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
 <1398354495-20782-17-git-send-email-iivanov@mm-sol.com>
 <20140430162705.GL23679@saruman.home>
In-Reply-To: <20140430162705.GL23679@saruman.home>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3UI8GE1009548

Signed-off-by:Tim Bird <Tim.bird@sonymobile.com>

Sent from my Sony Xperiaâ„¢ smartphone

---- Felipe Balbi wrote ----

>On Thu, Apr 24, 2014 at 06:48:11PM +0300, Ivan T. Ivanov wrote:
>> From: Tim Bird <tbird20d@gmail.com>
>> 
>> Fix the value used for Parallel Transceiver Select (PTS) for the MSM USB
>> controller.  This is a standard chipidea PORTSC definition, where
>> a PHY_TYPE of 10b (<<30) is ULPI and 11b (<<30) is SERIAL.
>> Fix the definitions and use them correctly in the driver code.
>> 
>> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
>
>since you're the one sending the patch, you must add your signed-off-by
>too. If you reply with your SoB I'll add to proper patches.
>
>-- 
>balbi
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
