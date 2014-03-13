Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaCMUHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbaCMUHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:07:17 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 0/3] irqchip: sun4i: various cleanups
Date: Thu, 13 Mar 2014 20:49:59 +0100
Message-Id: <1394740202-1952-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

So here is a second patchset for irq-sun4i.c I'm not 100% sure about these
changes. They all seem the right thing to do, but they definitely need a
good review first.

I've run various tests with this set and everything works as advertised.

Regards,

Hans
