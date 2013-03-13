Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3CMGdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:33:24 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:47532 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3CMGdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:33:21 -0400
Date: Wed, 13 Mar 2013 07:33:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: delete "if !ULTRA_HAS_POPULATION_COUNT"
Message-ID: <20130313063320.GC19681@merkur.ravnborg.org>
References: <1363120519.3137.148.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363120519.3137.148.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 09:35:19PM +0100, Paul Bolle wrote:
> Commit 2d78d4beb64eb07d50665432867971c481192ebf ("[PATCH] bitops:
> sparc64: use generic bitops") made the default of GENERIC_HWEIGHT depend
> on !ULTRA_HAS_POPULATION_COUNT. But since there's no Kconfig symbol with
> that name, this always evaluates to true. Delete this dependency.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
