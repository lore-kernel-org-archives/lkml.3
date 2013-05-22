Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3EVNYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:24:40 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36642 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3EVNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:24:38 -0400
Message-ID: <519CC70C.30604@elopez.com.ar>
Date: Wed, 22 May 2013 10:24:28 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (net-next
 tree related)
References: <20130522155537.3cc0ee6254775cc88cf2218f@canb.auug.org.au>
In-Reply-To: <20130522155537.3cc0ee6254775cc88cf2218f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

El 22/05/13 02:55, Stephen Rothwell escribió:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc32 defconfig)
> produced this warning:
> 
> drivers/net/ethernet/sun/sunbmac.c: In function 'bigmac_set_multicast':
> drivers/net/ethernet/sun/sunbmac.c:998:6: warning: unused variable 'i' [-Wunused-variable]
> 
> Introduced by commit bfd428daaf61 ("net: ethernet: sun: initialize
> variables directly") from the net-next tree.
> 

Thank you for notifying.

After a second look at the code, I see the apple and korina patch
counterparts also leave an extra i variable now; the dm9000 patch should
be unaffected as it still uses i for other things.

@David, what would you like me to do? I can send another set of patches
fixing this, resend the full original series but fixed, or resend just
the affected patches.

Emilio
