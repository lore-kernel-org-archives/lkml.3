Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaGJQOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:14:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59981 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGJQOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <53BEB951.2040207@ti.com>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
	<1404928177-26554-7-git-send-email-bigeasy@linutronix.de>
	<20140710070948.GH28884@atomide.com>
	<53BEB5AF.7010604@linutronix.de>
	<53BEB951.2040207@ti.com>
Date: Thu, 10 Jul 2014 11:14:28 -0500
Message-ID: <CAGo_u6r57s6kpF81W-hq96PFizOp3m+XEh3bmzJOp0oPHYRNCg@mail.gmail.com>
Subject: Re: [PATCH 6/6] tty: serial: Add 8250-core based omap driver
From: "menon.nishanth@gmail.com" <menon.nishanth@gmail.com>
To: Carlos Hernandez <ceh@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, linux-serial@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:03 AM, Carlos Hernandez <ceh@ti.com> wrote:
> 1) Append no_console_suspend to bootargs
Not needed. ideally with pinctrl wakeup capability, this should work.
if you do no_console_suspend, the module is not powered down.
