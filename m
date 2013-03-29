Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3C2PVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:21:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11062 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3C2PVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:21:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 29 Mar 2013 08:20:40 -0700
Message-ID: <5155B24B.2030601@nvidia.com>
Date: Fri, 29 Mar 2013 08:24:59 -0700
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Romain Naour <romain.naour@openwide.fr>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] gpio: remove GENERIC_GPIO completely
References: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 06:11 AM, Alexandre Courbot wrote:
> If I can get a few acks on these (or at least the first two ones) I'd like to
> include them into my next branch as soon as possible so points of breakage can
> be fixed. There are indeed a few new users of GENERIC_GPIO (CC Romain, I sent a
> warning but saw no action so far) in the next tree and compilation will break
> for them.

Alternatively, Grant may want to pull all the patches I did so far - 
they are in next for more than 10 days now and no complain has been 
raised. Also it's probably better to keep all GPIO-related changes into 
the same tree.

Alex.

