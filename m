Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3A3QYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:24:44 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:34010 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab3A3QYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:24:41 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1359563066!22919801!24
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mori Hess <fmhess@users.sourceforge.net>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Date: Wed, 30 Jan 2013 10:24:26 -0600
Subject: RE: [PATCH -next] staging: comedi: ISA DMA drivers should depend on
 ISA_DMA_API
Thread-Topic: [PATCH -next] staging: comedi: ISA DMA drivers should depend
 on ISA_DMA_API
Thread-Index: Ac3+4WAH3zD/fYnPSx23T6v8wrriFgAJJxzQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F00207A707B4BE@AUSP01VMBX24.collaborationhost.net>
References: <1359547209-15712-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1359547209-15712-1-git-send-email-geert@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0UGOjJb015786

On Wednesday, January 30, 2013 5:00 AM, Geert Uytterhoeven wrote:

> m68k allmodconfig:

<snip>

> Make PCL816, PCL818, DAS16, DAS1800, DT282X, and NI_AT_A2150 depend on
> ISA_DMA_API to fix this.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Looks like we have the first fallout from Greg's patch to enable comedi for
all architectures... :-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
