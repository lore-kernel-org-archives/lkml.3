Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3GVXTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:19:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54335 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751717Ab3GVXTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:19:36 -0400
Message-ID: <1374535175.2061.84.camel@joe-AO722>
Subject: Re: crypto: ux500: Fix logging, make arrays const, neatening
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Masanari Iida <standby24x7@gmail.com>,
        Andreas Westin <andreas.westin@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto <linux-crypto@vger.kernel.org>
Date: Mon, 22 Jul 2013 16:19:35 -0700
In-Reply-To: <CACRpkdaUQaDbtr5rOyob_G5ggSZLUVOWU+TmhL51Jw_c0S+T0A@mail.gmail.com>
References: <1373896210-21316-1-git-send-email-standby24x7@gmail.com>
	 <1374003464-32302-1-git-send-email-standby24x7@gmail.com>
	 <1374008808.1949.37.camel@joe-AO722>
	 <CACRpkdaUQaDbtr5rOyob_G5ggSZLUVOWU+TmhL51Jw_c0S+T0A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 00:35 +0200, Linus Walleij wrote:
> Have you tested this on hardware or is it compile-tested only?

Hi Linus.

Compile tested only.  Not tested on real devices.  -ENOHARDWARE.

cheers, Joe

