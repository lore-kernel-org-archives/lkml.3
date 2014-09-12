Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaILLIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:08:18 -0400
Received: from mout.web.de ([212.227.15.14]:62431 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaILLIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:08:16 -0400
Message-ID: <5412D413.3080404@users.sourceforge.net>
Date: Fri, 12 Sep 2014 13:08:03 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Coccinelle <cocci@systeme.lip6.fr>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Coccinelle: Semantic patch for replacing puts with
 putc
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk> <1410513954-28909-2-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1410513954-28909-2-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:jI/5el270HgOm5fXK/dQ6ELDvH7EcYOfV3Q2xZgVuIY7gk0Ns9R
 XifLyoK9NB05rO+WVymwcn/7PwWpPY8CFMWgZikIOEMyChCrOX70R2/V9XcXcTHPx0UOJav
 FDUVoizmEjRRMJ8qcPCrAnssu+XPzowg5Fptc8WD4f3WgQE2/gf5gN6xcKM3D8dHAwe15Rw
 a3X3BIcHZk0bklu+cU6IA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Using seq_puts to write a one-character string is suboptimal,
> since puts has to call strlen().

Are there any more functions which work with such strings in a similar way?
Would it make sense to look also at other function names?

Regards,
Markus
