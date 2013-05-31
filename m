Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab3EaRjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:39:19 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48593 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3EaRjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:39:13 -0400
X-Auth-Info: GDtXjbLYED4G5v4y7agZDRuC6TXS+ZbQHmbAGzbnfpY=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: David Gibson <david@gibson.dropbear.id.au>, jdl@jdl.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mmarek@suse.cz, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, linux-kbuild@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] dtc: Ensure #line directives don't consume data from the next line
References: <1370020450-18136-1-git-send-email-swarren@wwwdotorg.org>
X-Yow: Give them RADAR-GUIDED SKEE-BALL LANES and VELVEETA BURRITOS!!
Date: Fri, 31 May 2013 19:38:57 +0200
In-Reply-To: <1370020450-18136-1-git-send-email-swarren@wwwdotorg.org>
	(Stephen Warren's message of "Fri, 31 May 2013 11:14:10 -0600")
Message-ID: <87sj13dp72.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> writes:

> Fix this by replacing {WS} with [ \t] so that it can't match line-breaks.

I think the other uses of {WS} shouldn't span lines either.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
