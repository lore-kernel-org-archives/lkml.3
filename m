Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3FNWHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:07:41 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:39632 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3FNWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:07:39 -0400
Date: Sat, 15 Jun 2013 00:07:33 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        "Steven J. Hill" <sjhill@realitydiluted.com>
Subject: Re: [PATCH 12/31] MIPS: Add instruction format information for WAIT,
 MTC0, MFC0, et al.
Message-ID: <20130614220733.GB18936@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-13-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-13-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:16PM -0700, David Daney wrote:

> To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
>  Sanjay Lal <sanjayl@kymasys.com>
> Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
> Subject: [PATCH 12/31] MIPS: Add instruction format information for WAIT,
>  MTC0, MFC0, et al.

Looks good.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

I wonder if somebody could throw in microMIPS equivalent to this patch?

  Ralf
