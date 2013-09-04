Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab3IDSZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:25:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57935 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab3IDSZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:25:11 -0400
Message-ID: <52277B02.9010707@wwwdotorg.org>
Date: Wed, 04 Sep 2013 12:25:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] ARM: tegra: support for Trusted Foundations
References: <1377770268-14014-1-git-send-email-acourbot@nvidia.com> <52262D8F.9060706@wwwdotorg.org> <52269B92.3070304@nvidia.com>
In-Reply-To: <52269B92.3070304@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 08:31 PM, Alex Courbot wrote:
> On 09/04/2013 03:42 AM, Stephen Warren wrote:
>> On 08/29/2013 03:57 AM, Alexandre Courbot wrote:
>>> New version revised according to comments received for v3. Hopefully
>>> it will be good enough to be merged.
>>
>> Aside from the small issue in patch 1/5, the series,
>> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> 
> Thanks! I have adressed the issues you mentioned and will submit v5
> soon. Despite the fact this adds some non-Tegra stuff, will you be able
> to take it into your tree, or should I ask someone else?

I would like to see an ack from the core ARM maintainer (Russell) on
patch 1/5 (also CC'ing arm-soc maintainers for their opinion).

If I get that, I think it makes sense to take the series through the
Tegra tree. I can always create a stable branch for patch 1/5 if needed
to resolve conflicts elsewhere (e.g. Russell's trees or arm-soc) and/or
allow other people to build on top of that patch.
