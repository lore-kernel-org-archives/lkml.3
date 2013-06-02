Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3FBSkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 14:40:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45536 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3FBSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 14:40:51 -0400
Message-ID: <51AB9177.8000508@infradead.org>
Date: Sun, 02 Jun 2013 11:39:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.10-rc4
References: <alpine.LFD.2.03.1306021745220.6129@pixel.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.03.1306021745220.6129@pixel.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/13 01:45, Linus Torvalds wrote:
> 
> Another week, another -rc. But this time (at least for now) only as a git 
> tree - for people actually using the tar-balls and patches, I apologize, 
> but I'm a complete moron, and didn't install kup, its perl dependencies, 
> and my kup release scripts on the pixel before the trip.
> 
> And while I can read and write email, and git is fine with just a few 
> (flaky) kB/s internet throughput I have access to right now, installing 
> the perl packages etc seems to be a pipe dream.
> 
> I suspect nobody actually uses the tar-balls and patches, since git is so 
> much more convenient and efficient, so hopefully nobody cares. But I'll 
> rectify the lack eventually. Hopefully within a day or two, as my "yum 
> update" actually completes. And if not in a day or two, then when I get 
> back home a few days later.

I still use tarballs and patches, fwiw.

I do expect that some day you will just completely drop doing those
and I will handle that (with some changes).

-- 
~Randy
