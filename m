Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3EVObf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:31:35 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:54538 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3EVObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:31:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH 0/7] ARM: ux500: Change naming convention for pinctrl 
Date: Wed, 22 May 2013 15:22:54 +0100
Message-Id: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our naming convention started off sensibly, but with the addition of
more supported platforms it's slipped a little. Most compatible strings
standardise themselves with "<vendor>,<device_name>-<device_type>",
which we had initially with "stericsson,nmk-pinctrl", but with more
devices to support we now have a tail, so we are using
"<vendor>,<driver_name>-<device_type>-<device_name>", which is
unsuitable.

This patch-set ensures the standard convention is used again.

