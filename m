Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaBENC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:02:56 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:46874 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBENCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:02:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140124022154.GA13428@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	<1390339396-3479-60-git-send-email-paul.gortmaker@windriver.com>
	<CACRpkdYk6cOO-JZbe887ihJaWE5JMjuXm3EVcZmE1jCeL2BODQ@mail.gmail.com>
	<20140124095827.1ee8ddcfed8d1c8e0a6d3dbd@canb.auug.org.au>
	<20140124022154.GA13428@windriver.com>
Date: Wed, 5 Feb 2014 14:02:52 +0100
Message-ID: <CACRpkdYF2f1Ekp6JYwntj+UhbceWtMN==yKC7emsXHfktcZZsg@mail.gmail.com>
Subject: Re: [PATCH 59/73] drivers/gpio: delete non-required instances of
 include <linux/init.h>
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 3:21 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:

> For what it is worth, I'm not removing any patches from my series file
> until they explicitly conflict and/or become redundant.  If a maintainer
> says they are adding the patch, I add a comment in the series file, but
> I don't remove them until I see them come into next via another branch,
> and/or sfr reports a conflict/redundancy.

So I can add these patches to my devel branches now I think?

Yours,
Linus Walleij
