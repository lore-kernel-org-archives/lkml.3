Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaDGXVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:21:50 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43832 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaDGXVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:21:49 -0400
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Greg Kurz <gkurz@linux.vnet.ibm.com>, benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org, paulus@samba.org,
        anton@samba.org, nfont@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc/le: enable RTAS events support
In-Reply-To: <20140404072750.20016.18969.stgit@bahia.local>
References: <0140402175658.1b4a8c4d@bahia.local> <20140404072750.20016.18969.stgit@bahia.local>
User-Agent: Notmuch/0.16 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 08 Apr 2014 09:21:41 +1000
Message-ID: <8738hoenei.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040723-9574-0000-0000-00000CE2BECE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kurz <gkurz@linux.vnet.ibm.com> writes:
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

Acked-by: Stewart Smith <stewart@linux.vnet.ibm.com>

