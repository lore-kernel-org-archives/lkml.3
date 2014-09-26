Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaIZD5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:57:09 -0400
Received: from ozlabs.org ([103.22.144.67]:52655 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbaIZD5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:57:07 -0400
Date: Fri, 26 Sep 2014 13:57:03 +1000
From: Anton Blanchard <anton@samba.org>
To: Michael Neuling <mikey@neuling.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 01/15] powerpc/cell: Move spu_handle_mm_fault() out of
 cell platform
Message-ID: <20140926135703.3f94a7e1@kryten>
In-Reply-To: <1411028820-29933-2-git-send-email-mikey@neuling.org>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	<1411028820-29933-2-git-send-email-mikey@neuling.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> Currently spu_handle_mm_fault() is in the cell platform.
> 
> This code is generically useful for other non-cell co-processors on
> powerpc.
> 
> This patch moves this function out of the cell platform into
> arch/powerpc/mm so that others may use it.
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>

Reviewed-by: Anton Blanchard <anton@samba.org>

Anton
