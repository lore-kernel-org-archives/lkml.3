Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab3KKITg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:19:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60269 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3KKIT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:19:28 -0500
Date: Mon, 11 Nov 2013 13:37:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] uprobes: Don't assume that arch_uprobe->insn/ixol is
 u8[MAX_UINSN_BYTES]
Message-ID: <20131111080750.GD2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131109175350.GA17412@redhat.com>
 <20131109175406.GA17430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131109175406.GA17430@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111108-0928-0000-0000-00000348F3EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-11-09 18:54:06]:

> arch_uprobe should be opaque as much as possible to the generic
> code, but currently it assumes that insn/ixol must be u8[] of the
> known size. Remove this unnecessary dependency, we can use "&" and
> and sizeof() with the same effect.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

