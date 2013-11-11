Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3KKH0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:26:49 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57856 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3KKH0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:26:43 -0500
Date: Mon, 11 Nov 2013 12:45:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
Message-ID: <20131111071555.GB2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131109190344.GA32281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131109190344.GA32281@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111107-6688-0000-0000-0000035C54F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-11-09 20:03:44]:

> 1. Don't include asm/uprobes.h unconditionally, we only need
>    it if CONFIG_UPROBES.
> 
> 2. Move the definition of "struct xol_area" into uprobes.c.
> 
>    Perhaps we should simply kill struct uprobes_state, it buys
>    nothing.
> 
> 3. Kill the dummy definition of uprobe_get_swbp_addr(), nobody
>    except handle_swbp() needs it.
> 
> 4. Purely cosmetic, but move the decl of uprobe_get_swbp_addr()
>    up, close to other __weak helpers.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

