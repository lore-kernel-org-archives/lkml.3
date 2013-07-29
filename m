Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3G2OgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:36:19 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:35440 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3G2OgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:36:17 -0400
Date: Mon, 29 Jul 2013 18:36:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
Message-ID: <20130729143614.GN2524@moon>
References: <20130726201807.GJ8661@moon>
 <51F67777.6060609@parallels.com>
 <20130729141417.GM2524@moon>
 <51F67B27.9040004@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F67B27.9040004@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 06:24:39PM +0400, Pavel Emelyanov wrote:
> 
> For non-x86 case there are stubs in include/asm-generic/pgtable.h that would
> act as if the CONFIG_MEM_SOFT_DIRTY is off.

Yeah, thanks, I'll update.
