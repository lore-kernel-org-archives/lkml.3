Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab3GSON4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:13:56 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39045 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3GSONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:13:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 00/13] ARM: ux500: Misc Device Tree patches
Date: Fri, 19 Jul 2013 15:13:36 +0100
Message-Id: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patchset we:

1. Remove nodes which aren't pertinent to Snowball from its DTS file
2. Provide ST-Ericsson's DTS[I] files with a ste-* prefix
3. Remove the old u9540.dts file 

