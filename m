Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaKTNvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:51:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaKTNvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:51:04 -0500
Date: Thu, 20 Nov 2014 14:51:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Radek Dostal <radek.dostal@streamunlimited.com>
cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, arnd@arndb.de
Subject: Re: [PATCH RESEND] ARM: dts: bcm63138: change "interupts" to
 "interrupts"
In-Reply-To: <1416235278-15759-1-git-send-email-radek.dostal@streamunlimited.com>
Message-ID: <alpine.LNX.2.00.1411201450180.4454@pobox.suse.cz>
References: <5460F9EF.5010605@gmail.com> <1416235278-15759-1-git-send-email-radek.dostal@streamunlimited.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Radek Dostal wrote:

> all other nodes in bcm63138.dtsi use "interrupts", this had to be just a typo
> which never got noticed, even it may have quite some consequences.
> 
> Signed-off-by: Radek Dostal <radek.dostal@streamunlimited.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Dear all,
> 
>  resending the previous patch with added Acked-by from Florian Fainelli. I
>  did not hear anything back for almost a week. Additionally CC to
>  trivial@kernel.org as it may qualify for it.

As this got acked by Florian and I don't see it in linux-next as of today, 
I am taking it.

-- 
Jiri Kosina
SUSE Labs
