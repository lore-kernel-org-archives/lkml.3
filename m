Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbaJ2OVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:21:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:56786 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbaJ2OVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:21:19 -0400
Date: Wed, 29 Oct 2014 15:21:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heena Sirwani <heenasirwani@gmail.com>
cc: opw-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de
Subject: Re: [PATCH v8 0/2] Added ktime_get_seconds() and
 ktime_get_real_seconds()
In-Reply-To: <cover.1414578445.git.heenasirwani@gmail.com>
Message-ID: <alpine.DEB.2.11.1410291518300.5308@nanos>
References: <cover.1414578445.git.heenasirwani@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Heena Sirwani wrote:

> The following patchset adds two functions as follows:
> 	-ktime_get_seconds() to return tv_sec portion of
> 	ktime_get_ts64().
> 	-ktime_get_real_seconds() to return tv_sec portion of
> 	ktime_get_real_ts64().
> 
> Changes in v8:
> 	-changed type of ktime_sec to unsigned long
> 	- Added a patch with ktime_get_real_seconds().

Heena, thanks for your patience and for following up to the reviews.

I merged the lot into tip timers/2038. Thats a new branch reserved for
the 2038 work.

Arnd, feel free to pull that branch into your tree for the patches
which depend on those interfaces.

Thanks,

	tglx

