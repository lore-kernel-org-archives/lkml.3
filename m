Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3IKHmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:42:55 -0400
Received: from ares07.inai.de ([5.9.24.206]:53603 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3IKHmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:42:53 -0400
Date: Wed, 11 Sep 2013 09:42:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Matt Porter <matt.porter@linaro.org>
cc: Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Introducing libgadget 0.0.1
In-Reply-To: <20130904172532.GA10973@ohporter.com>
Message-ID: <alpine.LSU.2.11.1309110940430.29134@nerf07.vanv.qr>
References: <20130904172532.GA10973@ohporter.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2013-09-04 19:25, Matt Porter wrote:

>With the move to configfs for creation of arbitrary USB composite gadgets,
>I found myself wanting a simple C library to configure and parse gadgets
>in a system. It has no other dependencies other than libc itself.
>
>It can be found at:
>
>	git://git.linaro.org/people/mporter/libgadget.git

Hm but there is already a libgadget (and not just one) if you query a 
particular search engine entitled Google :}

>$ mkdir /config
>$ mount -t configfs none /config

Do your tools support input of a different location?
(systemd mounts configfs at /sys/kernel/config.)

>$ gadget-acm-ecm
>$ show-gadgets
>ID 1d6b:0104 'g1'
>[...]

