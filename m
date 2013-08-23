Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3HWHIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:08:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:46227 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3HWHIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:08:34 -0400
Message-ID: <52170A6F.6040009@linutronix.de>
Date: Fri, 23 Aug 2013 09:08:31 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.9-rt5
References: <20130822182127.GA7606@linutronix.de> <5216F81A.4050203@localhost>
In-Reply-To: <5216F81A.4050203@localhost>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 07:50 AM, Fernando Lopez-Lezcano wrote:
> On 08/22/2013 11:21 AM, Sebastian Andrzej Siewior wrote:
>> - hwlat improvements by Steven
>>
>> Known issues:
> ...
> Trying to build I get (in make modules):
> 
> ERROR: "__udivdi3" [drivers/misc/hwlat_detector.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

looks like someone forgot to do do_div() instead / which fails on 32bit
if used on a 64bit dividend.

Will fix later.

> (find attached the final configuration used for building)
> -- Fernando

Sebastian
