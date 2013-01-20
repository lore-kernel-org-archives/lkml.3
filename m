Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3ATRFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 12:05:34 -0500
Received: from [198.137.202.10] ([198.137.202.10]:42693 "EHLO mail.zytor.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab3ATRFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 12:05:33 -0500
Message-ID: <50FC2366.1000509@zytor.com>
Date: Sun, 20 Jan 2013 09:03:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tom St Denis <tstdenis@elliptictech.com>
CC: Mike Galbraith <bitbucket@online.de>, Eric Dumazet <erdnetdev@gmail.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: IPsec AH use of ahash
References: <2012247681.93123.1358694444237.JavaMail.root@elliptictech.com>
In-Reply-To: <2012247681.93123.1358694444237.JavaMail.root@elliptictech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2013 07:07 AM, Tom St Denis wrote:
>
> In all likelihood I will submit a revised CMAC patch but it'll take
> time before I can get business hours to work on it.  So instead of
> having a maintainer just touch it up we're all going to lose out
> because of pride?
>

It's not about pride.  It is about the fact that maintainers don't 
scale.  A single troublesome contributor can easily take up as much 
maintainer time as over a dozen contributors who know how to work well 
with their upstream.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

