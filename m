Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3EMK5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:57:48 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:17145 "HELO
	mail-ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753070Ab3EMK5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:57:46 -0400
Message-ID: <5190C720.50903@keymile.com>
Date: Mon, 13 May 2013 12:57:36 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/8] genirq: Support for irq domains in generic irq chip - V2
References: <20130506142348.321859745@linutronix.de>
In-Reply-To: <20130506142348.321859745@linutronix.de>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2013 10:57:36.0715 (UTC) FILETIME=[ADBBE9B0:01CE4FC8]
X-ESAFE-STATUS: [srvchber1306.keymile.net] Mail allowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 05/06/2013 04:30 PM, Thomas Gleixner wrote:
> Changes vs. V1:
>
> 	- Fixed the generic chip pointer thinko (Sebastian Hesselbarth)
>
> 	- Proper support for mask cache
>
> 	- Read mask hardware only for the first map of an generic chip
>            instance
>
> 	- sun4i prefix irq functions proper
>

[removed all other individual recipients to avoid useless garbage],

thanks for taking care of this. Sorry for the late response, I have been 
away for a whole week with no email access.

I understand you are providing generic changes and it would be up to us 
to update individual drivers so to take advantage of those semplifications.
Please forgive me if I got this all wrong though.

I've got a few questions then:

1) What happened to your initial proposal of renaming gc->mask_cache to 
gc->shared_mask_cache? Does that mean you intend to keep compatibility 
so individual drivers can be updated one at a time?

2) What shall we do with such potential patches for individual drivers, 
given the dependencies on your work? Wait until yours get merged?

3) [a bit OT] anyone got a clue why I cannot see my previous patch 
series on patchwork.kernel.org? Neither can I find from within 
http://marc.info/?l=linux-kernel.
I looked up '[PATCH v3b 0/9] refactoring for mask_cache' and could not 
find it, only some replies to the thread were shown.
Patches/messages from the same thread are correctly shown on 
news.gmane.org under gmane.linux.kernel, though threading is broken on 
my reader; they will not be found through the web interface for 
gmane.linux.kernel though.
I noticed this was a cross post to linux-kernel@vger.kernel.org and 
stable@vger.kernel.org (which I guess is something that should not be 
done under any circumstances). And all the above works just fine for 
-stable as opposed to LKML.
Could this cross-posting be the root cause for this whole mess?

Thanks!
Gerlando
