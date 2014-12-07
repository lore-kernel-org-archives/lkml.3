Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaLGTfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:35:38 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:53743 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaLGTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:35:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: robert.ward114@googlemail.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] /dev/mem as optional device + associated tidy up
Date: Sun, 07 Dec 2014 20:35:31 +0100
Message-ID: <8719187.RB9WVc9E5S@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
References: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:icxB9ZoNKNw2j6f4G3TU8jTUNd+dYpex2bpChV7qlCbqEgBAJf7
 jIgsO1I/5Ho7wiqzoF7leaHgibSv4Q6nf0EiLCop+yZd9zSDKMcOywky1S39nFoHPMr+vST
 yzWIKy8j/WK9ofOsD6emUCw2CzQnjMn5PuhB7+nzZATsl1I+rUQe98d+mFK7h/QKt9hOxxX
 /S4OzsjSg1uCfeGeLZgDw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2014 15:40:32 robert.ward114@googlemail.com wrote:
> From: Rob Ward <robert.ward114@googlemail.com>
> 
> Makes the /dev/mem device optional using the CONFIG_DEVMEM option.
> 
> This brings /dev/mem in line with /dev/kmem so it can de disabled. 
> Disabling /dev/mem is preferable on devices that do not require
> direct access to memory in order to improve security. This is especially
> true on platforms where no restiction is placed on the areas of memory
> that can be accessed(for example mips) without custom modifcations to
> the kernel source.
> 
> The implementation of this functionality declares the mem_fops structure
> as __maybe_unused to eliminate the need for #ifdefs throughout the
> file.
> 
> Follow up changes are present to change CONFIG_DEVKMEM and CONFIG_DEVPORT
> to use __maybe_unused. This simplifies the code and make the
> implementations consistent.
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
