Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3GYWFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:05:11 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41977 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3GYWFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:05:08 -0400
Date: Fri, 26 Jul 2013 00:05:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH, re-send] Always trap on BUG()
Message-ID: <20130725220502.GI18254@gmail.com>
References: <201307051738.35930.arnd@arndb.de>
 <20130715151612.9499c2b2ad40e88d183a4600@linux-foundation.org>
 <20130715222755.GY24642@n2100.arm.linux.org.uk>
 <51E47924.9030005@zytor.com>
 <20130723093628.GC19786@gmail.com>
 <51EF1936.7090801@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF1936.7090801@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chen Gang <gang.chen@asianux.com> wrote:

> On 07/23/2013 05:36 PM, Ingo Molnar wrote:
> > 
> > (the crazies can keep a separate patch to remove even more of BUG() to win 
> > a K or two.)
> > 
> 
> Excuse me, my English is not quite well, I do not quite understand your
> meaning, could you please repeat again in details or say more clearly ?

I meant: those people who'd like to have the tiny 
additional space savings offered by !CONFIG_BUG (and are 
crazy enough to live with non-determinism in exchange for a 
measly payment of 1 KB), can apply a separate, out of tree 
patch just fine and don't need upstream kernel support.

Thanks,

	Ingo
