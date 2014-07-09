Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaGIJiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:38:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48162 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbaGIJiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:38:17 -0400
Message-ID: <53BD0D0C.9090708@ti.com>
Date: Wed, 9 Jul 2014 15:06:12 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>
Subject: Re: [PATCH v3 1/7] regulator: tps65218: Add fixed_uV fields for dcdc5
 and dcdc6
References: <1404884193-20580-1-git-send-email-j-keerthy@ti.com> <1404884193-20580-2-git-send-email-j-keerthy@ti.com> <20140709091442.GN30458@sirena.org.uk>
In-Reply-To: <20140709091442.GN30458@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 02:44 PM, Mark Brown wrote:
> On Wed, Jul 09, 2014 at 11:06:27AM +0530, Keerthy wrote:
>> Add fixed_uV fields for dcdc5 and dcdc6.
> This doesn't apply against current code, can you please check and
> resend?  There were some cleanups from Felipe that just went in, it
> looks like a collision with them.
Yup. They touch the same lines. Those patches were not yet taken
before i posted. I will rebase and post.

Thanks,
Keerthy
