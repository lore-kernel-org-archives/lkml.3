Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaFBNlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:41:20 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39069 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaFBNlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:41:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de
Cc: linus.walleij@linaro.org, grant.likely@linaro.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH 0/3] i2c: Relax requirement for I2C Device ID tables
Date: Mon,  2 Jun 2014 14:41:00 +0100
Message-Id: <1401716463-23457-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

After this patch-set, it should become possible to start stripping out
those unnecessary I2C Device ID tables that are currently lurking around,
mostly redundantly.  Firstly, we create a look-up function whose job it
is to match I2C device name to a Device Tree node.  Then we add some
extra protection in i2c_match_id(), so that we can call the function with
a NULL parameter. This in turn aids to the elegance of the final change
which relaxes the requirement of a populated .id_table.

Kind regards,
Lee

