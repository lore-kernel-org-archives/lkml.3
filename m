Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbaAHUdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:33:07 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:61457 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbaAHUdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:33:02 -0500
MIME-Version: 1.0
In-Reply-To: <1389211403.678513817@f123.i.mail.ru>
References: <1389210991-23688-1-git-send-email-john.tobias.ph@gmail.com>
	<1389211403.678513817@f123.i.mail.ru>
Date: Wed, 8 Jan 2014 18:33:00 -0200
Message-ID: <CAOMZO5DR0YGc=V5PJ6xy5PNwa9LCVfnS9gbRh1yW9wLo_oTEtw@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: imx: add select on ARCH_MXC for cpufreq support
From: Fabio Estevam <festevam@gmail.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: John Tobias <john.tobias.ph@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 6:03 PM, Alexander Shiyan <shc_work@mail.ru> wrote:

> Maybe better:
> select HAVE_IMX_ANATOP if ARCH_MULTI_V6_V7

mx31, mx35, mx51 and mx53 do not have this ANATOP block.

Regards,

Fabio Estevam
