Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3LTPGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:06:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:33320 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3LTPGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:06:01 -0500
Message-ID: <52B45CD7.5030404@linutronix.de>
Date: Fri, 20 Dec 2013 16:05:59 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: pavel@pavlinux.ru
CC: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12.5 CRASH/FREEZE
References: <52A9CC77.20904@linaro.org> <52AA1CC0.30307@pavlinux.ru> <20131220141008.GE10249@linutronix.de> <52B45AEB.2060508@pavlinux.ru>
In-Reply-To: <52B45AEB.2060508@pavlinux.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 03:57 PM, Pavel Vasilyev wrote:
> 
> Same bug if attach to ehci hub.
> 
> ksoftird/0 process of loading the CPU upto 100% Sometimes process
> irq17/0 - ehci_hcd  or xhci_hcd. After taking the camera out of the
> socket, the load does not fall, keyboard and console blocked

Okay, but this problem is unique to your webcam. Keyboard & mice to
work as usual?
Could please provide me the addr2line either for the ehci or xhci? I've
been browsing to the code and I didn't see anything obvious.

Sebastian
