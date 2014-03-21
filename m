Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaCUTKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:10:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:52660 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaCUTKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:10:07 -0400
Message-ID: <532C8E8B.9080406@linutronix.de>
Date: Fri, 21 Mar 2014 20:10:03 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Gerhard Sittig <gsi@denx.de>
CC: Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dinh Nguyen <dinguyen@altera.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: dts: socfpga: add gpio pieces
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de> <1395345324-18299-4-git-send-email-bigeasy@linutronix.de> <20140321172434.GB3998@book.gsilab.sittig.org>
In-Reply-To: <20140321172434.GB3998@book.gsilab.sittig.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 06:24 PM, Gerhard Sittig wrote:
> On Thu, Mar 20, 2014 at 20:55 +0100, Sebastian Andrzej Siewior wrote:
>>
>> The cycloneV has three gpio controllers, each one with 29 gpios. This patch
>> adds the three controller with the gpio driver which is now sitting the
>> gpio tree.
> 
> The third bank should have 27 pins, only the first two have 29.

It is not a bank it is a complete controller. Why 27 pins? The
reference manual says that there register 0…28.

> The commit message probably should not discuss which git tree a
> driver currently resides in.  This is just a temporary detail
> which no longer applies to the mainline source base where your
> patch will end up in.

This patch adds a binding which is not in kernel. It is worth to
mention.

> 
> 
> virtually yours
> Gerhard Sittig
> 
Sebastian
