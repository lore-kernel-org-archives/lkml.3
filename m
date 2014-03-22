Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbaCVGDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:03:52 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51921 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaCVGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:03:50 -0400
Message-ID: <532D27C3.10907@gmail.com>
Date: Sat, 22 Mar 2014 00:03:47 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Branimir Maksimovic <branimir.maksimovic@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 15995MB available under Linux but 16329MB available under Win
 7
References: <532D131B.1050606@gmail.com>
In-Reply-To: <532D131B.1050606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/14 10:35 PM, Branimir Maksimovic wrote:
> This really puzzles me.
>
> bmaxa@maxa:~$ lspci -v -s 01:00.0
> 01:00.0 VGA compatible controller: NVIDIA Corporation GF114 [GeForce GTX
> 560 Ti] (rev a1) (prog-if 00 [VGA controller])
>      Subsystem: CardExpert Technology Device 0801
>      Flags: bus master, fast devsel, latency 0, IRQ 52
>      Memory at f4000000 (32-bit, non-prefetchable) [size=32M]
>      Memory at e8000000 (64-bit, prefetchable) [size=128M]
>      Memory at f0000000 (64-bit, prefetchable) [size=64M]
>      I/O ports at e000 [size=128]
>      [virtual] Expansion ROM at f6000000 [disabled] [size=512K]
>      Capabilities: <access denied>
>      Kernel driver in use: nvidia
>
> bmaxa@maxa:~$ dmesg | grep Mem
> [    0.000000] Memory: 16358808K/16721316K available (7232K kernel code,
> 1106K rwdata, 3456K rodata, 1324K init, 1432K bss, 362508K reserved)

Can you post your full dmesg output?

>
> Everything is clear most of reserved RAM goes to VGA mapping?
>
> But, Windows resource monitor and task manager says just around 50MB
> hardware reserved?
>
> So I have tried different kernel boot parameters to no avail.
> So question is: Does Windows magically maps VGA to upper addresses
> (beyond 16GB)
> or simply Windows does not reports all reserved RAM?
>
> When I disable memory remap in BIOS Windows reports 500MB more reserved,
> but Linux adds this 500MB to 300MB reserved giving around 800MB.
>
> CPU is i5 3570k, motherboard z77, 16GB of DD3 RAM, AMI BIOS.
>
> Branimir.
>

