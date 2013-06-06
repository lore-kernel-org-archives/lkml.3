Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3FFGQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 02:16:32 -0400
Received: from ozlabs.org ([203.10.76.45]:42438 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab3FFGQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 02:16:30 -0400
Date: Thu, 6 Jun 2013 16:16:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Paul Mackerras <paulus@au.ibm.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: add missing include to book3s_xics.c
Message-ID: <20130606061609.GA17615@drongo>
References: <51AF5F1F.6010903@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AF5F1F.6010903@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 11:54:07AM -0400, Jeff Mahoney wrote:
> This fixes the following build failure:
> arch/powerpc/kvm/book3s_xics.c:812: error: implicit declaration of function 'get_tb'
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Acked-by: Paul Mackerras <paulus@samba.org>

Could you please send this to linuxppc-dev@ozlabs.org so it gets into
patchwork and doesn't get forgotten?

Paul.
