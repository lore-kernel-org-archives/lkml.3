Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab3EAXOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:14:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42173 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3EAXOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:14:06 -0400
Date: Thu, 2 May 2013 00:09:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Miguel Boton <mboton.lkml@gmail.com>, Russ Anderson <rja@sgi.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v7 08/11] arm, Remove unused restart_mode fields from
	some arm subarchs
Message-ID: <20130501230957.GS14496@n2100.arm.linux.org.uk>
References: <1367428011-17123-1-git-send-email-holt@sgi.com> <1367428011-17123-9-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367428011-17123-9-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 12:06:48PM -0500, Robin Holt wrote:
> These restart_mode fields are not used at all.  Remove them to make
> moving the reboot= cmdline options to the general kernel easier.

Your grepping is faulty.  They are most definitely used.
