Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966792Ab3DQTAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:00:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966507Ab3DQTAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:00:18 -0400
Date: Wed, 17 Apr 2013 12:00:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V5 4/7] drivers/rtc: DA9058 RTC driver
Message-Id: <20130417120016.feb8dbb4b010128c78fa1286@linux-foundation.org>
In-Reply-To: <201304171644.r3HGi4TM023877@latitude>
References: <201304171644.r3HGi4TM023877@latitude>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013 17:33:35 +0100 Anthony Olech <anthony.olech.opensource@diasemi.com> wrote:

> This patch is relative to linux next-20130417
> 
> This is the RTC component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the CORE component driver of the DA9058 MFD.

The driver could use devm_request_threaded_irq() rather than the bare
request_threaded_irq().

Otherwise it looks OK to me.  Please include this in whatever tree
contains the "CORE component driver of the DA9058 MFD" and merge it
upstream via that tree.

Please also ask Stephen to include the whole tree into linux-next at
the earliest possible time, if it isn't already there.
