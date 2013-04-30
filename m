Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3D3H0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:26:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:59516 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3D3H0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:26:23 -0400
Message-ID: <517F721D.60907@linutronix.de>
Date: Tue, 30 Apr 2013 09:26:21 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Bernhard Schiffner <bernhard@schiffner-limbach.de>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.8.10-rt6
References: <20130429201202.GB7979@linutronix.de> <23187402.mkEEi1N7Lp@bs8>
In-Reply-To: <23187402.mkEEi1N7Lp@bs8>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 10:46 PM, Bernhard Schiffner wrote:
>> Known issues:
>>
>>     - SLxB is broken on PowerPC.
>>     - suspend / resume seems to program program the timer wrong and wait
>>       ages until it continues.
> 
> Yes, it's a annoying problem here too.
> How can I help to solve it?

Are you referring to the PowerPC issue or suspend / resume?

> Bernhard

Sebastian
