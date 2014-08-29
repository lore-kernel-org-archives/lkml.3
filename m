Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaH2MbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:31:22 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:48172 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaH2MbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:31:21 -0400
MIME-Version: 1.0
In-Reply-To: <1409103573-4082-1-git-send-email-a@phire.org>
References: <1409103573-4082-1-git-send-email-a@phire.org>
Date: Fri, 29 Aug 2014 14:31:20 +0200
Message-ID: <CACRpkdaxJT_V4G=fmX4Tnrn3mFQEOt3eQCLiS1JkZuHDmG77yQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: bt8xx: fix release of managed resources
From: Linus Walleij <linus.walleij@linaro.org>
To: Michael Auchter <a@phire.org>
Cc: Michael Buesch <m@bues.ch>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 3:39 AM, Michael Auchter <a@phire.org> wrote:

> These resources are managed by devres, and should not be explicitly
> released.
>
> Signed-off-by: Michael Auchter <a@phire.org>

Patch applied for fixes.

Yours,
Linus Walleij
