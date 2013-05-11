Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3EKMaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 08:30:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48433 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3EKMaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 08:30:03 -0400
Date: Sat, 11 May 2013 13:29:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v10 00/11] Shutdown from reboot_cpuid without stopping
	other cpus.
Message-ID: <20130511122939.GC18614@n2100.arm.linux.org.uk>
References: <1368273447-11958-1-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368273447-11958-1-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 06:57:16AM -0500, Robin Holt wrote:
> We recently noticed that reboot of a 1024 cpu machine takes approx 16
> minutes of just stopping the cpus.  The slowdown was tracked to commit
> f96972f.
...
> Cc: Russell King <linux@arm.linux.org.uk>

Looks good now.  Acks supplied for relevant patches to ARM.  For the
remainder which will still have a Cc: line like the above, please
change it to use rmk+kernel@arm.linux.org.uk

Thanks.
