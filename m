Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3LRQ4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:56:07 -0500
Received: from mxout1.idt.com ([157.165.5.25]:45109 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab3LRQ4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:56:05 -0500
X-Greylist: delayed 1009 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 11:56:01 EST
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Matt Porter <mporter@kernel.crashing.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 3/3] drivers: rapidio: Remove unused function
 rio_remove_sysfs_dev_files() in rio-sysfs.c
Thread-Topic: [PATCH 3/3] drivers: rapidio: Remove unused function
 rio_remove_sysfs_dev_files() in rio-sysfs.c
Thread-Index: AQHO+MuBQJLfuOSZH06uk9t+zFnrm5paKTGQ
Date: Wed, 18 Dec 2013 16:38:57 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BED3206@corpmail1.na.ads.idt.com>
References: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
 <63f565ae73de586db2277390618fa781535a55f9.1386926041.git.rashika.kheria@gmail.com>
In-Reply-To: <63f565ae73de586db2277390618fa781535a55f9.1386926041.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBIGuUQD011915

On Sat, Dec 14, 2013 at 7:53 AM Rashika Kheria wrote:
> Subject: [PATCH 3/3] drivers: rapidio: Remove unused function
> rio_remove_sysfs_dev_files() in rio-sysfs.c
> 
> This patch removes the function rio_remove_sysfs_dev_files() in rio-
> sysfs.c because it is unused.
> 

This function will be in use after RapidIO hot plug is added. This work in progress now.
To avoid bringing it back later I prefer to keep it. 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
