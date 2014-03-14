Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaCNKT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:19:56 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60477 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaCNKTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140312201606.GN3327@book.gsilab.sittig.org>
References: <1394148326-21556-1-git-send-email-garyservin@gmail.com>
	<CACRpkdbjbjeePQipX7nbLXJKnYWFUXhbDLEXPGX5z+EE8R-q3Q@mail.gmail.com>
	<20140312201606.GN3327@book.gsilab.sittig.org>
Date: Fri, 14 Mar 2014 11:19:53 +0100
Message-ID: <CACRpkdbmXvnwO-da85TreVWC2PEdXUG9M0b_cBgr_CyZtTjs3g@mail.gmail.com>
Subject: Re: [PATCH] gpio: mcp23s08: Trivial: Fixed coding style issues
From: Linus Walleij <linus.walleij@linaro.org>
To: Gerhard Sittig <gsi@denx.de>
Cc: Gary Servin <garyservin@gmail.com>, Alexandre Courbot <gnurou@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 9:16 PM, Gerhard Sittig <gsi@denx.de> wrote:

>  'sizeof' is an operator, very much like a unary minus or
> unary ampersand which neither require parentheses.  So either of
> "sizeof(x)" as well as "sizeof x" are legal with regard to the C
> language.  It's just that the community prefers "sizeof(x)" for
> the improved readability.

You're right, amazingly. Thanks for teaching me something new
today!

Yours,
Linus Walleij
