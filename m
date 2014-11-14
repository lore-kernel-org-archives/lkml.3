Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaKNAUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:20:35 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38830 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaKNAUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:20:14 -0500
Subject: Re: [PATCH] x86: remove arbitrary instruction size limit in
 instruction decoder
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        jkenisto@us.ibm.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <20141112225352.D49917A8@viggo.jf.intel.com>
References: <20141112225352.D49917A8@viggo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Nov 2014 16:20:07 -0800
Message-ID: <1415924407.4306.2.camel@oc1026406570.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111400-8236-0000-0000-000006E92735
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 14:53 -0800, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The current x86 instruction decoder steps along through the
> instruction stream but always ensures that it never steps farther
> than the largest possible instruction size (MAX_INSN_SIZE).
...

> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Jim Keniston <jkenisto@us.ibm.com>

