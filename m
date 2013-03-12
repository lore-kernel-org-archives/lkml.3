Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3CLH5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 03:57:55 -0400
Received: from linux-sh.org ([111.68.239.195]:37728 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab3CLH5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 03:57:53 -0400
Date: Tue, 12 Mar 2013 16:57:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-sh@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: remove references to CPU_SUBTYPE_SH7764
Message-ID: <20130312075747.GB3553@linux-sh.org>
References: <1363002940.3137.65.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363002940.3137.65.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:55:40PM +0100, Paul Bolle wrote:
> Since release v2.6.29 the tree has a few references to the Kconfig
> symbol CPU_SUBTYPE_SH7764 and the Kconfig macro
> CONFIG_CPU_SUBTYPE_SH7764. But the actual symbol CPU_SUBTYPE_SH7764 was
> never added to the tree. Perhaps no one noticed because these references
> were never used alone. Anyhow, these references serve no purpose and
> can be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Looks fine, I suspect Iwamatsu-san let this trickle in from some vendor
branch given that these are all his drivers. I'll queue it up, thanks.
