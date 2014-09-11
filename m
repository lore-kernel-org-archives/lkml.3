Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaIKECz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:02:55 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:57542 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaIKECy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:02:54 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "dsd@gentoo.org" <dsd@gentoo.org>,
        "kune@deine-taler.de" <kune@deine-taler.de>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()
Thread-Topic: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()
Thread-Index: AQHPvfy4VhjwVefflUWmSbacV2I4ZZv7bmfA
Date: Thu, 11 Sep 2014 04:02:49 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF4D490@EU-MBX-02.mgc.mentorg.com>
References: <1407827133-29493-1-git-send-email-sanjeev_sharma@mentor.com>
	 <FDC088D3B5555644AE135ED28A7ABDE94DF2FDC2@EU-MBX-02.mgc.mentorg.com>
	 (sfid-20140819_083957_833442_DEE44B0A)
 <1408707084.4349.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1408707084.4349.0.camel@jlt4.sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8B430Fg020974

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Friday, August 22, 2014 5:01 PM
To: Sharma, Sanjeev
Cc: dsd@gentoo.org; kune@deine-taler.de; linville@tuxdriver.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()

On Tue, 2014-08-19 at 06:39 +0000, Sharma, Sanjeev wrote:
> Ping for review the patch.

> Make sure it compiles ...

Any update on this patch ?

Regards
Sanjeev Sharma

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
