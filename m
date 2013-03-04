Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3CDCeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:34:24 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40150 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3CDCeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:34:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130304022354.4540F3E14C0@localhost>
References: <1362139302-23048-1-git-send-email-linus.walleij@stericsson.com>
	<20130302092309.692CD3E17F8@localhost>
	<20130304022354.4540F3E14C0@localhost>
Date: Mon, 4 Mar 2013 03:34:22 +0100
Message-ID: <CACRpkdZCv==kHqQ1FA5UQhLEBnmBZ3gud8JtHf1pavyDv+x5-w@mail.gmail.com>
Subject: Re: [PATCH] gpio: stmpe: pass DT node to irqdomain
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 3:23 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sat, 02 Mar 2013 09:23:09 +0000, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Applied, thanks.
>>
>> I've got a small branch of fixes that I need to send to Linus for v3.9,
>> and then I'll leave the rest of the bug fixes to you.
>
> This patch breaks for CONFIG_OF=n. I've dropped it and it will need to be reposted.

Yeah :-/

I posted a reply to the linux-next build failure with some question
on how we make the OF integration less errorprone, it's currenly
way to easy to cause things like this because of missing #ifdefs
for non-OF platforms.

Yours,
Linus Walleij
