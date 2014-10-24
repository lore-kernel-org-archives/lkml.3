Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbaJXPwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:52:30 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48334 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJXPw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:52:29 -0400
Date: Fri, 24 Oct 2014 16:52:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Documenation: kmemleak: Add an explanation about
 CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y case.
Message-ID: <20141024155220.GF20534@e104818-lin.cambridge.arm.com>
References: <1414153500-29150-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414153500-29150-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 01:24:58PM +0100, Masanari Iida wrote:
> Following 2 patches add an explanation about CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y 
> case.
> 
> Masanari Iida (2):
>   Documentation: Add default kmemleak off case in kernel-parameters.txt
>   Documentation: Add CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF case

Both patches look fine to me.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
