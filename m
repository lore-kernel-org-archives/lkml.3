Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3EAFCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 01:02:15 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37597 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3EAFCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 01:02:05 -0400
Message-ID: <5180A1AD.4060409@linux.vnet.ibm.com>
Date: Wed, 01 May 2013 10:31:33 +0530
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: manual merge of the vfs tree with the powerpc tree
References: <20130501120636.0e54681b2dfb7ebe6aeb27c4@canb.auug.org.au>
In-Reply-To: <20130501120636.0e54681b2dfb7ebe6aeb27c4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050104-2000-0000-0000-00000BEED98C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 07:36 AM, Stephen Rothwell wrote:
> Hi Al,
>
> Today's linux-next merge of the vfs tree got a conflict in
> arch/powerpc/kernel/rtas_flash.c between commit fb4696c39573
> ("powerpc/rtas_flash: Fix bad memory access") from the powerpc tree and
> commits ad18a364f186 ("powerpc/rtas_flash: Free kmem upon module exit")
> and 2352ad01409d ("ppc: Clean up rtas_flash driver somewhat") from the
> vfs tree.
>

Stephen,

As Ben mentioned earlier, there are outstanding comments from me which
needs to be addressed by Dave, before its merged.


-Vasant

> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>

