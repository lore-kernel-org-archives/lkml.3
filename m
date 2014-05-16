Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaEPVJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:09:42 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40332 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaEPVJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:09:40 -0400
Date: Fri, 16 May 2014 17:09:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] dma-mapping: pci: Add devm_ interface for
 pci_map_single
Message-ID: <20140516210937.GP5379@htj.dyndns.org>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
 <1400228799-8832-4-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400228799-8832-4-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:26:37AM +0300, Eli Billauer wrote:
> 
> Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
> ---
>  Documentation/driver-model/devres.txt |    2 ++
>  include/asm-generic/pci-dma-compat.h  |   17 +++++++++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)

The patch looks fine to me but can you please cc PCI subsystem
maintainer and please do so for other patches too.

Thanks.

-- 
tejun
