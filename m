Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3AMSD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 13:03:27 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54089 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3AMSD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 13:03:26 -0500
MIME-Version: 1.0
Date: Sun, 13 Jan 2013 16:03:24 -0200
Message-ID: <CAOMZO5ASEY6iHQ1UekR88vWZPutsJdiEuGkpsC2Civ6ezi2NGg@mail.gmail.com>
Subject: Build error on kernel/rcutree.c
From: Fabio Estevam <festevam@gmail.com>
To: paul.mckenney@linaro.org
Cc: linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

When building ARM imx_v4_v5_defconfig the following error shows up on
linux-next 20130111:

kernel/rcutree.c:808:2: error: implicit declaration of function
'rcu_jiffies_till_stall_check' [-Werror=implicit-function-declaration]
kernel/rcutree.c:941:6: error: 'rcu_cpu_stall_suppress' undeclared
(first use in this function)

Is this a known issue?

Regards,

Fabio Estevam
