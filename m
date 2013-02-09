Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3BINYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 08:24:42 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63697 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3BINYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 08:24:40 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
To: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
In-Reply-To: <1359822572-26009-8-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-8-git-send-email-acourbot@nvidia.com>
Date: Sat, 09 Feb 2013 13:24:35 +0000
Message-Id: <20130209132435.169133E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  3 Feb 2013 01:29:29 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Make sure gpiolib works internally with descriptors and (chip, offset)
> pairs instead of using the global integer namespace. This prepares the
> ground for the removal of the global gpio_desc[] array and the
> introduction of the descriptor-based GPIO API.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Despite Linus' comments, I've gone ahead and applied this. I think it is
a worthwhile change on its own and it feeds into the future work than
needs to be done. Any of the stuff he brought up can be addressed in
follow-on patches.

g.

