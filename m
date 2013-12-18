Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3LRNeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:34:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35065 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab3LRNeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:34:05 -0500
Date: Wed, 18 Dec 2013 14:33:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
Message-ID: <20131218133357.GB12222@pd.tnic>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
 <52B0A93E.7090503@cogentembedded.com>
 <20131217190610.GJ30592@pd.tnic>
 <1930396.DGXdd6ZaUD@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1930396.DGXdd6ZaUD@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Bart,

long time no see! :-)

On Wed, Dec 18, 2013 at 02:23:52PM +0100, Bartlomiej Zolnierkiewicz wrote:
> No, it means that there are legacy PATA chipsets (some used by embedded
> platforms) that are only supported by IDE host drivers.

I know what it means - I was asking a provocative question. :)

> If there is a need I should be able to help in converting these
> leftover drivers before we delete IDE. Once I find some time I will go
> over all IDE host drivers, make a list of affected hardware and start
> a discussion on IDE removal.

While this is a generous offer, I'd leave it to the people who actually
need that functionality to do the conversion themselves. But this is
just me.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
