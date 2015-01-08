Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbbAHIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:16:59 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58479 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752686AbbAHIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:16:58 -0500
Date: Thu, 8 Jan 2015 09:16:55 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 0/8] Atmel System Timer cleanups
Message-ID: <20150108091655.0dfebcff@bbrezillon>
In-Reply-To: <1420459605-24561-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1420459605-24561-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Mon,  5 Jan 2015 13:06:37 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> This patch sets cleans up the system timer driver.
> 
> The main goal is to get rid of the mach/ headers dependency. At the same time,
> it introduces proper probing and locking (using a regmap) for the watchdog
> driver.

Thanks for this rework!

You can add my:

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
