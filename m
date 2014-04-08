Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaDHCrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:47:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41432 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbaDHCrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 22:47:14 -0400
Message-ID: <5343632B.5040205@linux.vnet.ibm.com>
Date: Mon, 07 Apr 2014 21:47:07 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kurz <gkurz@linux.vnet.ibm.com>, benh@kernel.crashing.org
CC: tony@bakeyournoodle.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, paulus@samba.org, anton@samba.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc/le: enable RTAS events support
References: <0140402175658.1b4a8c4d@bahia.local> <20140404072750.20016.18969.stgit@bahia.local>
In-Reply-To: <20140404072750.20016.18969.stgit@bahia.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040802-7182-0000-0000-00000A45F622
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 02:35 AM, Greg Kurz wrote:
> The current kernel code assumes big endian and parses RTAS events all
> wrong. The most visible effect is that we cannot honor EPOW events,
> meaning, for example, we cannot shut down a guest properly from the
> hypervisor.
> 
> This new patch is largely inspired by Nathan's work: we get rid of all
> the bit fields in the RTAS event structures (even the unused ones, for
> consistency). We also introduce endian safe accessors for the fields used
> by the kernel (trivial rtas_error_type() accessor added for consistency).
> 
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>

Looks good, thanks for getting this done Greg.
-Nathan

