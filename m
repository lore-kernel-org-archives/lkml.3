Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaHQPni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:43:38 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:59106 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaHQPng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:43:36 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat5hNPsyOiM
X-RZG-CLASS-ID: mo00
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: PROBLEM: bindings for drivers/mfd/twl4030-power.c
Date: Sun, 17 Aug 2014 17:43:30 +0200
Message-Id: <FAC7D7E5-1D05-4D63-821F-C56D3AAA8FF9@goldelico.com>
Cc: Marek Belisko <marek@goldelico.com>
To: Tony Lindgren <tony@atomide.com>, Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to make ti,use_poweroff work on 3.17-rc1 for the GTA04 board.
Poweroff was broken for a while and I found that the driver isn't loaded at all.

It appears to me that commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
did rename the compatible entry from "ti,twl4030-power" to "ti,twl4030-power-reset"
but this was not documented in the bindings and of course our DT does not
match.

Even your commit message talks about "ti,twl4030-power" although I can't find it
in the code.

Are "ti,twl4030-power" and "ti,twl4030-power-reset" doing the same?

BR,
Nikolaus