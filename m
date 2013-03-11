Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3CKWHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:07:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3CKWHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:07:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.9-rc1] clk: vt8500: Fix variable name '*prate' compile error
Date: Mon, 11 Mar 2013 22:07:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Mike Turquette <mturquette@linaro.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org
References: <1361900052-66917-1-git-send-email-tim.gardner@canonical.com> <20130226192958.14870.54664@quantum>
In-Reply-To: <20130226192958.14870.54664@quantum>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303112207.32619.arnd@arndb.de>
X-Provags-ID: V02:K0:elfct8bSt7H7EJMKCaCGYL+qRVFHY5iWQuK0ZqVpPPR
 mBPDr51i2UqDbtabvZQqXINVZnkryqbTQn0IdrNrDiIZE9i3oE
 0xhh35Pc519OE7PMcteaYSUs80BY7OlwKAkXqxN2MIAfIjV87P
 YsnHRHukqOLQNyPC4WOr5c8vJivpKfJAgm4hJL53NGqyJIMhbz
 JqZgtmKq5dG0qxKCfH6rdMOCNAHvyBwXqjTkyTkQ9760JagECr
 SM1jXTmyOx5APOuqMOTsgk6Y/i9+SaPkfveukLpFXj1NgY6axD
 o3Aiuj+XcQ3afwOkd88jMl0G3ag/c8HuPWwvsusZNYXWF8fS6U
 4hlvceB7tULwNT2wIj8I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2013, Mike Turquette wrote:
> Quoting Tim Gardner (2013-02-26 09:34:12)
> > commit 72480014b86c8b51fb51c5c6a0525876055c37c7 (clk: vt8500: Fix device clock
> > divisor calculations) introduced a compile error in the naming of a variable in
> > vt8500_dclk_set_rate(). It looks like a simple cut and paste error.
> > 
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> 
> Tim,
> 
> Thanks for the fix.  I already have a fix for this issue in my clk-fixes
> branch.  In fact I forgot to bundle this one and another mxs fix in my
> 3.9 pull request so I'll send a follow-up bugfix branch after 3.9-rc1 is
> out.
> 

It seems this hasn't happened yet. I also don't see the patch in linux-next.
Is this patch still on your radar?

	Arnd
