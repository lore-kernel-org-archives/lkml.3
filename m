Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbbASJjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:39:01 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:53823 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbbASJi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:38:59 -0500
Message-ID: <1421660338.9655.21.camel@x220>
Subject: Re: [PATCH v4] ARM: mvebu: remove two selects of ARM_ERRATA_753970
From: Paul Bolle <pebolle@tiscali.nl>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 10:38:58 +0100
In-Reply-To: <1421659937.9655.16.camel@x220>
References: <1421659937.9655.16.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2015 09:38:58.0857 (UTC) FILETIME=[C021E990:01D033CB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy, Joe,

On Mon, 2015-01-19 at 10:32 +0100, Paul Bolle wrote:
> ARM_ERRATA_753970 was renamed to PL310_ERRATA_753970 in v3.2, through
> commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for
> PL310 errata workarounds"). Still, two selects were added in v3.15 that
> used the previous name. So these selects have always been nops.
> 
> It is clear that the intention here was to select PL310_ERRATA_753970.
> But as, apparently, nothing broke for four releases we can assume
> PL310_ERRATA_753970 isn't actually needed. So let's not rename these two
> selects but just drop them instead.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Checkpatch in next-21050119 complains:
    ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for PL310 errata workarounds")'
    #7: 
    commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for
    
    total: 1 errors, 0 warnings, 14 lines checked
    
    Your patch has style problems, please review.

Perhaps it doesn't notice the quote spans two lines. Can this be fixed
please?

Thanks,


Paul Bolle

