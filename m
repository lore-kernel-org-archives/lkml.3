Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaF3N4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:56:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaF3N4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:56:52 -0400
From: Andreas Schwab <schwab@suse.de>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
References: <mvmvbri4k06.fsf@hawking.suse.de>
	<CAKv+Gu-NAVjMR-Jkw=W-8f7M5FSsQOSdzYN6A0kHDd1m0WA8EA@mail.gmail.com>
X-Yow: HUMAN REPLICAS are inserted into VATS of NUTRITIONAL YEAST...
Date: Mon, 30 Jun 2014 15:56:50 +0200
In-Reply-To: <CAKv+Gu-NAVjMR-Jkw=W-8f7M5FSsQOSdzYN6A0kHDd1m0WA8EA@mail.gmail.com>
	(Ard Biesheuvel's message of "Mon, 30 Jun 2014 15:38:41 +0200")
Message-ID: <mvmr4264i1p.fsf@hawking.suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:

> Out of curiosity, how did you trigger this failure? I have build this
> code numerous times (and so have others) and I have never seen this
> failure.

Did you ever start with a clean tree?

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
