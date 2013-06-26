Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3FZWgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:36:02 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53313 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3FZWf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:35:58 -0400
Date: Thu, 27 Jun 2013 00:35:54 +0200
From: Simon Baatz <gmbnomis@gmail.com>
To: Luis Henriques <luis.henriques@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [04/26] ARM: 7755/1: handle user space mapped pages in
 flush_kernel_dcache_page
Message-ID: <20130626223554.GB25104@schnuecks.de>
References: <lsq.1372214158.657310117@decadent.org.uk>
 <878v1x4510.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v1x4510.fsf@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Luis,

On Wed, Jun 26, 2013 at 10:04:11AM +0100, Luis Henriques wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
> 
> > 3.2.48-rc1 review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Simon Baatz <gmbnomis@gmail.com>
> >
> > commit 1bc39742aab09248169ef9d3727c9def3528b3f3 upstream.
> 
> Simon suggested Greg not to queue this patch for stable kernels as it
> breaks no-MMU ARM configs.  He will provide a follow-up patch that
> should go together with this one.

Fortunately, the follow-up patch is upstream now. It is commit
63384fd0b1509acf522a8a8fcede09087eedb7df (ARM: 7772/1: Fix missing
flush_kernel_dcache_page() for noMMU).

Thus, please add that patch as well. If it is too late to do this, my
suggestion would be to queue both of them together for the next cycle.

- Simon
