Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaKJVcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:32:12 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46890 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaKJVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:32:10 -0500
MIME-Version: 1.0
In-Reply-To: <1414514443-28943-2-git-send-email-wsa@the-dreams.de>
References: <1414514443-28943-1-git-send-email-wsa@the-dreams.de>
	<1414514443-28943-2-git-send-email-wsa@the-dreams.de>
Date: Mon, 10 Nov 2014 13:32:08 -0800
Message-ID: <CA+8MBbKZ4_OdrW=MurQ+OO8YW6x1iAF+thB5XASE4wXmXnREtQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/4] core: platform: add warning if driver has no owner
From: Tony Luck <tony.luck@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       if (!drv->owner)
> +               printk(KERN_WARNING "Driver '%s' needs an owner", drv->name);

This showed up in next-20141110 and on ia64 I see 44 "needs an owner" messages,
even from drivers like e1000.

Anyone else seeing anything like that? Or is some ia64 initialization path
missing an update?

-Tony
