Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3LUUBI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 15:01:08 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:56793 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab3LUUBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 15:01:07 -0500
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqshADXztVJV5qhFPGdsb2JhbAANS4tTsgOBKQMBAQEBOIJaAQEBAQIBeQULCyElDwIyFAYBDAEHAQGHeA2wJppCF48lB4Q2AQOiYop3
X-IronPort-AV: E=Sophos;i="4.95,528,1384297200"; 
   d="scan'208";a="741096951"
Message-ID: <52B5F3F0.30203@euromail.se>
Date: Sat, 21 Dec 2013 21:02:56 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: jcbian@pixcir.com.cn, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 7/9] Input: pixcir_i2c_ts: Implement Type B Multi Touch
 reporting
References: <1387358480-8313-1-git-send-email-rogerq@ti.com> <1387358480-8313-8-git-send-email-rogerq@ti.com> <20131218141841.GE28504@core.coreip.homeip.net> <52B288ED.80904@ti.com>
In-Reply-To: <52B288ED.80904@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

> It seems the controller the original driver was written for does not report
> touch ID and just reports 2 touch co-ordinates. I'm not sure how this fits into
> Type B reporting model.

Look in drivers/input/mouse/cypress_ps2.c for an example of how to deal with
anonymous touch coordinates.

Thanks,
Henrik

