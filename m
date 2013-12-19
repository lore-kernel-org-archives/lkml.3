Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3LSP2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:28:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:53643 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3LSP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:28:46 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: am335x: IIO/ADC fixes if used together with TSC, v2
Date: Thu, 19 Dec 2013 16:28:26 +0100
Message-Id: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two bigger issues here are fixed by the last patch incuding
- time outs on the iio/adc side while TSC&ADC is used together
- a lockup issue which occurs while TSC&ADC is used together.

v1…v2:
 - spelled checked and re-read each commit message and formated to
   subject line as Lee suggested.
 - removed am335x_tsc_se_set(), replaced am335x_tsc_se_tsc_set() by 
   am335x_tsc_se_set_cache() and adc variant is now named
   am335x_tsc_se_set_once()
 - Added Lee Jones' tags

Sebastian                                                            
