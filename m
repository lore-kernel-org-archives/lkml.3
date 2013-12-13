Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3LMJj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:39:29 -0500
Received: from lmv.inov.pt ([146.193.64.2]:47151 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab3LMJj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:39:26 -0500
Message-ID: <52AAD59B.7070203@inov.pt>
Date: Fri, 13 Dec 2013 09:38:35 +0000
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on
 S3C24XX.
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt> <52AA6909.8050200@inov.pt> <CACRpkdbBqqbkp3ap3Y=C5zC3Cq9jd+dL4iPZ9-2-Fd81GLAPBA@mail.gmail.com> <201312130942.03674.heiko@sntech.de>
In-Reply-To: <201312130942.03674.heiko@sntech.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (lmv.inov.pt [146.193.64.2]); Fri, 13 Dec 2013 09:38:39 +0000 (WET)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On 13-12-2013 08:42, Heiko Stübner wrote:
>
> But Jose, you should really really look into moving to devicetree with your
> platform, if you're not already doing so. Pinctrl support is already present,
> and I'm hopefull the move to the common clock framework I posted a few days
> ago might make it too.
>

I'm currently maintaining a deployed equipment whose development started 
some time ago, so I still need to use a 3.9 kernel with the traditional 
hardware initialization. But, of course, for any new developments based 
on the same S3C24XX platform, I will look in migrating to the device tree.

Best regards,
José Gonçalves
