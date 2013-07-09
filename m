Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3GIHNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:13:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:55922 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3GIHNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:13:07 -0400
Message-ID: <51DBB800.3010704@linutronix.de>
Date: Tue, 09 Jul 2013 09:13:04 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: George Cherian <george.cherian@ti.com>, linux-usb@vger.kernel.org,
        balbi@ti.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 0/5] Add phy support for AM335X platform using Generic
 PHy framework
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com> <51DB16A1.6010006@linutronix.de> <20130708203435.GB2596@localhost>
In-Reply-To: <20130708203435.GB2596@localhost>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 10:34 PM, Ezequiel Garcia wrote:
> Hi,

Hi,

> On Mon, Jul 08, 2013 at 09:44:33PM +0200, Sebastian Andrzej Siewior wrote:
> 
>> We need two nodes each one with a glue layer and a musb child node. The
>> instances crap in kernel has to vanish. Also that means your phy nodes
>> are wrong. This is not musb with two ports but two musb instances each
>> with one port.
>>
> 
> I agree completely. The current DT representation looks definitely odd,
> and we should be looking at improving it.
> 
> I wonder if this is now possible, given the DT is supposed to be stable ABI.

I posted this [0] and Felipe + Benoit were pro change. I am still not
sure if this is okay or just one glue layer per instance so I delay
this until I am sure. Stable or not, what currently have in is beyond
broken and it can't be fixed in kernel.
I would add some code to check for the old nodes and give a proper
warning and how to react. This should reduce the pain full search.

[0]
http://git.breakpoint.cc/cgit.cgi/bigeasy/linux.git/commit/?h=am335x_usb&id=0a60cd77ee50edd8cd07cbd699ed67b2c4b2ab93

Sebastian
