Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3EKM2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 08:28:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48415 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3EKM2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 08:28:02 -0400
Date: Sat, 11 May 2013 13:27:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russ Anderson <rja@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v10 08/11] arm, Remove unused restart_mode fields from
	some arm subarchs
Message-ID: <20130511122740.GA18614@n2100.arm.linux.org.uk>
References: <1368273447-11958-1-git-send-email-holt@sgi.com> <1368273447-11958-9-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368273447-11958-9-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 06:57:24AM -0500, Robin Holt wrote:
> These restart_mode fields are not used at all.  Remove them to make
> moving the reboot= cmdline options to the general kernel easier.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
