Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaK0WZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:25:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57113 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751040AbaK0WZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:25:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB development list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB / PM: Drop CONFIG_PM_RUNTIME from the USB core
Date: Thu, 27 Nov 2014 23:46:36 +0100
Message-ID: <3884361.r5D4k6hhsp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1736553.sGOphfkJmV@vostro.rjw.lan>
References: <1736553.sGOphfkJmV@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2014 11:45:15 PM Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so quite a few
> #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> depend on CONFIG_PM (or even dropped in some cases).
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in the USB core code.

Forgot to say, commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) is only in linux-next (via linux-pm) at the moment.

Rafael

