Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3LSV3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:29:23 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53523 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3LSV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:29:21 -0500
Message-ID: <1387488621.5567.52.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next: Tree for Dec 19 (target)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Date: Thu, 19 Dec 2013 13:30:21 -0800
In-Reply-To: <52B349B5.6090200@infradead.org>
References: <20131219165106.73f28ea8aa1bd059423cb5f8@canb.auug.org.au>
	 <52B349B5.6090200@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 11:32 -0800, Randy Dunlap wrote:
> On 12/18/13 21:51, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20131218:
> > 
> 
> 
> on i386:
> 
> drivers/built-in.o: In function `target_alua_state_check':
> (.text+0x3fc859): undefined reference to `__udivdi3'
> 
> 

Mmm, this appears to be a different unsigned long long division than the
one fixed in core_alua_state_lba_dependent() for 12192013 next code..

Strangely enough, I'm not able to reproduce with a local ARCH=i386
build..?

Hannes (CC'ed) care to take a look..?

--nab

