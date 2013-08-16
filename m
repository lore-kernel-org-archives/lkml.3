Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab3HPKqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:46:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:38705 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3HPKqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:46:38 -0400
Message-ID: <520E0307.70704@linutronix.de>
Date: Fri, 16 Aug 2013 12:46:31 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and trigger
 support
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com> <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com> <520CBEC6.8010400@kernel.org> <20130816100702.GD26895@linutronix.de> <520E0E22.4000403@kernel.org>
In-Reply-To: <520E0E22.4000403@kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 01:33 PM, Jonathan Cameron wrote:
> Ah, fixes-togreg is for this cycle, whereas new stuff like this needs
> to go on the togreg branch.  Hence please rebase on the togreg branch
> instead.

But he needs "iio: ti_am335x_adc: Fix wrong samples received on 1st
read" from that branch. How should the rebase be done?

> 
> That would explain it.

Sebastian
