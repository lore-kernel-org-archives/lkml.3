Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3E3UTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:19:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64640 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3E3UTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:19:36 -0400
MIME-Version: 1.0
In-Reply-To: <1369778570-23613-1-git-send-email-n.a.balandin@gmail.com>
References: <1369778570-23613-1-git-send-email-n.a.balandin@gmail.com>
Date: Thu, 30 May 2013 22:19:35 +0200
Message-ID: <CACRpkdb1w9+BZkdN-QOCCEOet-n+-H=+vRbOj3a7MEV+bu9fsw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] gpio: sx150x: convert to use devm_* functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Nikolay Balandin <n.a.balandin@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 12:02 AM, Nikolay Balandin
<n.a.balandin@gmail.com> wrote:
^
Above still doesn't make sense...

> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
>
> Use devm_* functions to make cleanup paths simpler.
>
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Applied this v3 version instead of v2.

Yours,
Linus Walleij
