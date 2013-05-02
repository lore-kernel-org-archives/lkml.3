Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab3EBPsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:48:21 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:38651 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3EBPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:48:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH 0/4] Fixing boot warnings in -next 
Date: Thu,  2 May 2013 16:48:06 +0100
Message-Id: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting -next on the u8500 based Snowball development board these
new warnings appeared. If applicable these should probably be filtered
though your -fixes branches.

