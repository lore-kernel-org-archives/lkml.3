Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaDGKN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 06:13:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:50054 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaDGKNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 06:13:24 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: jamie@jamieiles.com
Cc: atull@altera.com, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com
Subject: patches for the synopsys gpio controller, rount 3
Date: Mon,  7 Apr 2014 12:13:04 +0200
Message-Id: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my queue, updated with latest comments I recevied.
#1 fixes a list corruption bug
#4 enabled mixed edge/level user

the dts changes are not part of the series as I believe that they have
been already picked up by the maintainer(s).

Sebastian

