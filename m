Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3E0KYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:24:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56096 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab3E0KYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:24:13 -0400
Message-ID: <51A33447.80305@gmail.com>
Date: Mon, 27 May 2013 12:24:07 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, buytenh@wantstofly.org,
        jason@lakedaemon.net, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address workaround
 on DT ethernet
References: <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130525.210441.818472895703230779.davem@davemloft.net> <51A26B62.4050009@gmail.com> <20130527.022339.791886107453761860.davem@davemloft.net> <1369647565.3557.28.camel@pasglop>
In-Reply-To: <1369647565.3557.28.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/13 11:39, Benjamin Herrenschmidt wrote:
> On Mon, 2013-05-27 at 02:23 -0700, David Miller wrote:
>> Sparc has an of_set_property(), it needs to become generic.
>
> There is an of_update_property(), we could change the name though, yours
> is nicer :-)

Ben, David,

I had a quick look at sparc's of_set_property. Nothing special except it
depends on OF_DYNAMIC at some place. Using of_update_property instead
should be the correct function to use. Thanks for the hint, I'll update
the patches accordingly and send v5 hopefully by today.

Sebastian

