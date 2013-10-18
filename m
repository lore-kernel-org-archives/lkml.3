Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3JRASl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:18:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43945 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3JRASj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:18:39 -0400
Date: Thu, 17 Oct 2013 19:18:32 -0500
From: rkuo <rkuo@codeaurora.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        viro@zeniv.linux.org.uk, vgupta@synopsys.com, catalin.marinas@arm.com,
        will.deacon@arm.com, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        vapier@gentoo.org, msalter@redhat.com, a-jacquiot@ti.com,
        starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
        tony.luck@intel.com, fenghua.yu@intel.com, takata@linux-m32r.org,
        geert@linux-m68k.org, james.hogan@imgtec.com, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        lethal@linux-sh.org, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org
Subject: Re: [PATCH 09/29] hexagon: Use get_signal() signal_setup_done()
Message-ID: <20131018001832.GA23216@codeaurora.org>
References: <1381231942-4145-1-git-send-email-richard@nod.at>
 <1381231942-4145-4-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381231942-4145-4-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 01:32:22PM +0200, Richard Weinberger wrote:
> Use the more generic functions get_signal() signal_setup_done()
> for signal delivery.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks for the changes.  Compiled and tested briefly; the Hexagon part of
this looks fine.

If you want to compile test, there are newer versions of the toolchain
available here:

https://sourcery.mentor.com/GNUToolchain/release2568



Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
