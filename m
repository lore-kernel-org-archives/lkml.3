Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3EKM2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 08:28:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48424 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3EKM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 08:28:49 -0400
Date: Sat, 11 May 2013 13:28:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v10 11/11] Move arch/x86 reboot= handling to generic
	kernel.
Message-ID: <20130511122817.GB18614@n2100.arm.linux.org.uk>
References: <1368273447-11958-1-git-send-email-holt@sgi.com> <1368273447-11958-12-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368273447-11958-12-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 06:57:27AM -0500, Robin Holt wrote:
> Merge together the unicore32, arm, and x86 reboot= command line
> parameter handling.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Russ Anderson <rja@sgi.com>
> Cc: Robin Holt <holt@sgi.com>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: the arch/x86 maintainers <x86@kernel.org>
> Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
