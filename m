Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab3AKNe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:34:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45933 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab3AKNeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:34:23 -0500
Date: Fri, 11 Jan 2013 14:34:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-3.7.1: disable and reenable NMI watchdog => panic
Message-ID: <20130111133422.GA21882@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAN_LGv2RVeE88iJTeeYrin+_gKb9Pcg4feBcbKgEGEy8YmpCpQ@mail.gmail.com>
 <CAN_LGv1L3RLrwnzdN7oYM8ewjRoptGuK-4wQ9+oXWd+NK9CgNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAN_LGv1L3RLrwnzdN7oYM8ewjRoptGuK-4wQ9+oXWd+NK9CgNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 11:53:41PM +0600, Alexander E. Patrakov wrote:
> As illustrated by the screen photo [1] (sorry for bad quality),
> disabling and then reenabling the NMI watchdog panics the kernel
> (3.7.1). This is reproducible in qemu-kvm as well, but I could not get
> the nice panic message to pop up there (most of the time, the real
> machine just locks up, too). This bug is rather important, as
> laptop-mode-tools, by default, try to reenable this NMI watchdog when
> AC power appears, and this is how I caught the bug the first time.
> 
> [1] http://postimage.org/image/mjjifj1ip/

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=3935e89505a1c3ab3f3b0c7ef0eae54124f48905

should fix it.

See also thread here: http://marc.info/?i=20130109120732.GA8016@liondog.tnic

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
