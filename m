Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaGGKtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:49:06 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:47780 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaGGKtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:49:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140616095256.GN14323@lee--X1>
References: <1402297417-9338-1-git-send-email-ldewangan@nvidia.com>
	<20140616095256.GN14323@lee--X1>
Date: Mon, 7 Jul 2014 12:49:02 +0200
Message-ID: <CACRpkdYbV5zMoW3eLkYxbLLXEo4SWnqZgdkm+ONpBW-1s5pvYQ@mail.gmail.com>
Subject: Re: [PATCH] Doc: mfd: as3722: Add details of optional missing property
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:52 AM, Lee Jones <lee.jones@linaro.org> wrote:

> CC'ing Linus as he had an opinion.
>
> On Mon, 09 Jun 2014, Laxman Dewangan wrote:
>> Add details of following properties which are used on driver but
>> not documented on DT binding document.
>> - ams,enable-internal-int-pullup
>> - ams,enable-internal-i2c-pullup
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> Reported-by: Lee Jones <lee.jones@linaro.org>

I can live with this.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
