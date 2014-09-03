Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaICJoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:44:39 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:52695 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaICJoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:44:38 -0400
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 3 Sep 2014 11:44:22 +0200
X-Google-Sender-Auth: Z5ORaUXZ_AnetKP2cziDXgbz9ac
Message-ID: <CAL8zT=hNnRU3gbprVXOMt6FC9veRvQKRmS9gSeCm5-DNfGv-xg@mail.gmail.com>
Subject: PFUZE100 regulator not going off when PWRON is 0
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: lgirdwood@gmail.com, devicetree@vger.kernel.org, robh+dt@kernel.org,
        grant.likely@linaro.org, broonie@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a custom i.MX6 based board, but PMIC part is exactly the same
as the Freescale SabreSD board.
I have a reset button, which makes the PWRON signal on PFUZE100 go from 1 to 0.
I thought this would reset the chip, and thus all voltages would go to
0, but this is not the case. It seems that SWxOMODE registers are
involved in this process, accorgind to the datasheet, but I don't
think this is implemented right now.

I also removed regulator-always-on for my SW2 pin in order to get it
off, but this has no effect.

Thanks for your advices,
JM
