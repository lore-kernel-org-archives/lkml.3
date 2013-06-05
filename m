Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3FEIlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:41:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3FEIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:41:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Cc: andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: move mac_pton() to lib/net_utils.c
Date: Wed, 05 Jun 2013 10:41:45 +0200
Message-ID: <34263486.86xmxk21Lq@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130604.174323.350497684225826523.davem@davemloft.net>
References: <1370364386-5034-1-git-send-email-andy.shevchenko@gmail.com> <20130604.174323.350497684225826523.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MLNMDFsaQ81b2TWtbACGCm+qCAsuLycDJeerH/PY8d3
 eo6GcingNnFUrrkzSk2OqGkW4EIwVfRC8K8NcA+7aCALt2Qysr
 zI2l81VUwGNz9xNplb2WqbHp4ppKB9CdXPtHakYkqEG7xQhya4
 Dvfh5uG4j8v2yTj2LL4VLwq+B97RaOKJHnzCW8FpiLIQAtjVax
 R1+dLnjznkGs8jj++2mrNuihX30SdP6CS2AGCtlygkuzAkQMRa
 2NUYHNpOG9Ee0Ez0hoLsL0i5ySDODOp/eMMCAkr/n/yrYbIRrt
 YA7ed8BE8qnmiqOPiI/ABaPzCQgpLMVnV1BtXfF3Drw9cBW6wC
 lLKATweXTQDRpWeYnIdA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 17:43:23 David Miller wrote:
> From: Andy Shevchenko <andy.shevchenko@gmail.com>
> Date: Tue,  4 Jun 2013 19:46:26 +0300
> 
> > Since we have at least one user of this function outside of CONFIG_NET
> > scope, we have to provide this function independently. The proposed
> > solution is to move it under lib/net_utils.c with corresponding
> > configuration variable and select wherever it is needed.
> > 
> > Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Reported-by: Arnd Bergmann <arnd@arndb.de>
> 
> I do not see a mac_pton() usage under drivers/misc in any of my trees,
> so I really am not the person to apply this.

Greg merged the Andy's patch that added the usage in the char-misc tree,
which broke yesterday's linux-next for some 'randconfig' builds.

Can you provide an Ack for Greg to apply the patch to his tree?

	Arnd
