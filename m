Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3KQPuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 10:50:35 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47049 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3KQPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 10:50:28 -0500
Message-ID: <5288E5BF.2020608@gmail.com>
Date: Sun, 17 Nov 2013 16:50:23 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <52888F6D.6000802@gmail.com> <20131117132531.GB27696@pd.tnic>
In-Reply-To: <20131117132531.GB27696@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/11/2013 14:25, Borislav Petkov a écrit :
> On Sun, Nov 17, 2013 at 10:42:05AM +0100, Francis Moreau wrote:
>> Today I got a different behaviour, after resuming I got a
>> kernel panic. I could take a picture of the laptop screen:
>> http://imgur.com/f5uWFTY
> 
> Does archlinux ship the upstream kernel or do they have patches ontop?
> If "yes" to the last one, try reproducing this panic with the upstream
> kernel 3.12.

AFAIK, the kernel has 2 simple patches on top of the vanilla one.
They're both are trivial and can't be related to this issue.

You can have look to them here:
https://wiki.archlinux.org/index.php/Kernels#Official_packages

> 
> In general, how reliably can you reproduce the kernel panic with the
> upstream 3.12 kernel?
> 

Assuming that I'm running an upstream kernel, it's almost 100%
reproductible.

Thanks.
