Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3HWN6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:58:32 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52019 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3HWN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130812083051.GL7656@atomide.com>
References: <1376237628-1077-1-git-send-email-sre@debian.org>
	<1376237877-1740-1-git-send-email-sre@debian.org>
	<1376237877-1740-3-git-send-email-sre@debian.org>
	<20130812083051.GL7656@atomide.com>
Date: Fri, 23 Aug 2013 15:58:30 +0200
Message-ID: <CACRpkdbfGPx=j7byCdQV7Eghohr==mi+FyxSODE8kNTCgH-ayA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: OMAP2+: Add SSI driver configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Sebastian Reichel <sre@ring0.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:30 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Sebastian Reichel <sre@debian.org> [130811 09:25]:
>> From: Sebastian Reichel <sre@ring0.de>
>>
>> This patch configures and activates the OMAP SSI driver on the RX-51.
>
> Hmm, I'd rather see this be DT only driver at this point.

+1 on this.

Yours,
Linus Walleij
