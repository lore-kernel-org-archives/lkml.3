Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3LRQxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:53:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:46178 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3LRQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:53:14 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: am335x: IIO/ADC fixes if used together with TSC
Date: Wed, 18 Dec 2013 17:52:52 +0100
Message-Id: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series got a little bigger than expected with a biggy at the end.
I didn't managed to split the patches across the three subsystems it
touches due to the changes are required to keep it working and break the
logic.
Even in 5/5 which does three logical changes I didn't manage to split it
in three patches because the driver would not be functional (sometimes it would
get worse than before). This is all documented in the changelog. 
Thefore I ask to get this series applied via one tree, the iio tree which contains
or depends on the most changes.

The two bigger issues here are fixed by the last patch incuding
- time outs on the iio/adc side while TSC&ADC is used together
- a lockup issue which occurs while TSC&ADC is used together.

Sebastian

