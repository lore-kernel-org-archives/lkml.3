Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbaJaKRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:17:01 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61454 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbaJaKQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:16:59 -0400
Message-ID: <54536197.5050109@suse.cz>
Date: Fri, 31 Oct 2014 11:16:55 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "I. Schrey" <sy@schreyben.de>, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/197] 3.12.31-stable review
References: <cover.1413533329.git.jslaby@suse.cz> <5442512F.6000700@schreyben.de>
In-Reply-To: <5442512F.6000700@schreyben.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2014, 01:38 PM, I. Schrey wrote:
> Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.31 release.
>> There are 197 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> Hi Jiri,
> 
> the commit mentioned below has already been backported to 3.10 stable,
> can you please add it to 3.12 stable?
> 
> A test build with patch-3.12.31-rc1 and the commit in question
> builds and runs fine for me.

Hi, thanks for the pointer, now applied.

> -------- Forwarded message --------
> Subject:      linux-stable: backport usb related commit to 3.10 and 3.12?
> Date:      Sat, 23 Aug 2014 13:19:09 +0200
> To:
>     linux-kernel@vger.kernel.org
> 
> 
> 
> Greetings.
> 
> On an administered server, I noticed that there's a constant load
> around 0.70 when running kernels 3.10 and 3.12, even if
> the system is doing nothing, and in single user mode.
> Culprit seems to be the process 'khubd'.
> No such effect when running kernels 3.4 or 3.14.
> 
> I reverse bisected linux-stable and found that the following commit
> fixes it for me, for both kernel 3.10 and 3.12:
> 
> [08d1dec6f4054e3613f32051d9b149d4203ce0d2] usb:hub set hub->change_bits
> when over-current happens
> 
> 
> Could that commit be backported to the stable 3.10 and 3.12 series?



-- 
js
suse labs
