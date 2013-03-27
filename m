Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3C0PB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:01:27 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:38968 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3C0PB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130327061114.3356.57465.sendpatchset@w520>
References: <20130327061114.3356.57465.sendpatchset@w520>
Date: Wed, 27 Mar 2013 16:01:25 +0100
Message-ID: <CACRpkdY=UXZrRwuWp1JTePG71C=pAPc26kWWRqPZv_qZHc-_bg@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Make use of devm functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 7:11 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Update the Emma Mobile GPIO driver to make use of devm
> functions. This simplifies the error handling and makes
> the code more compact.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

I guess this is a resend. IIRC I just applied it some hours ago...

Yours,
Linus Walleij
