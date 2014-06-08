Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaFHJpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 05:45:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51012 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbaFHJpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 05:45:22 -0400
Date: Sun, 8 Jun 2014 11:45:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sitsofe Wheeler <sitsofe@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BISECTED][REGRESSION] Kernel does not boot on EeePC
Message-ID: <20140608094517.GB12736@gmail.com>
References: <20140608090223.GA8703@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140608090223.GA8703@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sitsofe Wheeler <sitsofe@gmail.com> wrote:

> Hi,
> 
> The latest kernel (c593e8978722f7f4a12932733cfeed6c0c74fbaa) refuses to
> boot on my EeePC - after grub is finished the screen just remains black
> and the only thing that does something is pressing the power button. The
> problem commit seems to be:
> 
> commit 3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f
> Author: Igor Mammedov <imammedo@redhat.com>
> Date:   Thu Jun 5 15:42:45 2014 +0200
> 
>     x86/smpboot: Initialize secondary CPU only if master CPU will wait for it

Argh, and have read this just a minute after expressing my hope that 
the hotplug fix is correct :-/

Linus, please revert commit 3e1a878b7ccdb.

  Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
