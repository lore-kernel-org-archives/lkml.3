Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab3C0IX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:23:58 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:42513 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3C0IX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <1362746292-4385-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1362746292-4385-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Wed, 27 Mar 2013 09:23:56 +0100
Message-ID: <CACRpkdYqnkOuQ22UCq-09EjKbOsb5_N=by=p=eGp2v6ajd6cXg@mail.gmail.com>
Subject: Re: [PATCH] gpio-lynxpoint: Add X86 dependency and io-port handling header.
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        mika.westerberg@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 1:38 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Lynxpoint gpio driver uses X86 specific io-ports to control gpios
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Patch applied with Mika's ACK.

Thanks!
Linus Walleij
