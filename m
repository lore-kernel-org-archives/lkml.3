Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbaIKQEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:04:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:41700 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaIKQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:04:38 -0400
Message-ID: <5411C810.7070906@linutronix.de>
Date: Thu, 11 Sep 2014 18:04:32 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>
CC: Peter Hurley <peter@hurleysoftware.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5411967A.6090406@hurleysoftware.com> <54119AAA.9080907@linutronix.de> <20140911151114.GD28458@ci00147.xsens-tech.local>
In-Reply-To: <20140911151114.GD28458@ci00147.xsens-tech.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 05:11 PM, Frans Klaver wrote:

> I can still reproduce it on am335x. I can get out of it as soon as
> something else gets written to the console though.
> 
> # echo "<3>something" >/dev/kmsg

Is this to stall it or to get out of it?

> 
> Frans

Sebastian
