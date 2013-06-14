Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3FNQMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:12:13 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:38629 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FNQML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:12:11 -0400
Date: Fri, 14 Jun 2013 18:11:48 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 10/31] mips/kvm: Implement ioctls to get and set FPU
 registers.
Message-ID: <20130614161148.GM15775@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-11-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-11-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:14PM -0700, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> The current implementation does nothing with them, but future MIPSVZ
> work need them.  Also add the asm-offsets accessors for the fields.

Just as a note, older MIPS FPUs only have fcr0 and fcr31.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
