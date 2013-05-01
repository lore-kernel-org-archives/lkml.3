Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab3EAXOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:14:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42176 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab3EAXOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:14:09 -0400
Date: Thu, 2 May 2013 00:13:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Miguel Boton <mboton.lkml@gmail.com>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v7 0/11] Shutdown from reboot_cpuid without stopping
	other cpus.
Message-ID: <20130501231347.GT14496@n2100.arm.linux.org.uk>
References: <1367428011-17123-1-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367428011-17123-1-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 12:06:40PM -0500, Robin Holt wrote:
> Andrew, Please do _NOT_ take this patch series yet.  I am sending this
> to you because you had comments on my -v6 submission.

Another reason for not applying this is that I believe it wilfully breaks
a bunch of ARM platforms - such as removing the 'g' reboot mode (for gpio
based reboot on PXA), and removing the 's' reboot mode off a bunch of ARM
platforms which have no way to do a hard reboot.

What scares me is that this is revision 7 of this patch set and this is
the first it's been noticed on ARM... Maybe this patch set didn't touch
ARM previously?
