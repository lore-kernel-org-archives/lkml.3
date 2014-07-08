Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaGHIRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:17:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37820 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaGHIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <1404193516-4384-2-git-send-email-acourbot@nvidia.com>
References: <1404193516-4384-1-git-send-email-acourbot@nvidia.com>
	<1404193516-4384-2-git-send-email-acourbot@nvidia.com>
Date: Tue, 8 Jul 2014 10:17:19 +0200
Message-ID: <CACRpkdZ9Uyk_GwcYt-VgBkgWTZfqJppp6HLYoPMs5tWWWxGJVA@mail.gmail.com>
Subject: Re: [RFC 1/3] gpio: always compile label support
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 7:45 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Compiling out GPIO labels results in a space gain so small that it can
> hardly be justified. Labels can also be useful for printing debug
> messages, so always keep them around.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied.

Yours,
Linus Walleij
