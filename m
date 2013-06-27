Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3F0SQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:16:47 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50527 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3F0SQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:16:45 -0400
Message-ID: <51CC81AA.7090406@windriver.com>
Date: Thu, 27 Jun 2013 14:17:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jayachandran C <jchandra@broadcom.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the cpuinit tree with the mips tree
References: <20130627184826.416dcb8c84d77f8455794829@canb.auug.org.au>
In-Reply-To: <20130627184826.416dcb8c84d77f8455794829@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-27 04:48 AM, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the cpuinit tree got a conflict in
> arch/mips/mm/tlbex.c between commits 8c24cb9d180b ("MIPS: Move generated
> code to .text for microMIPS") and d45accb44e19 ("MIPS: mm: Use scratch
> for PGD when !CONFIG_MIPS_PGD_C0_CONTEXT") from the mips tree and commit
> "MIPS: Delete __cpuinit/__CPUINIT usage from MIPS code" from the cpuinit
> tree.

Now fixed/refreshed, thanks!

P.
--

> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> Ralf, your merge commit e6d254aea905 ("Merge branch '3.10-fixes' into
> mips-for-linux-next") left some conflict markers in this file which I
> have removed as well.
> 
