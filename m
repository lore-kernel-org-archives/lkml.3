Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaGJNMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:12:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51861 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaGJNMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:12:46 -0400
Message-ID: <53BE90CF.5060407@ti.com>
Date: Thu, 10 Jul 2014 18:40:39 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>
Subject: Re: [PATCH v4] regulator: tps65218: Add fixed_uV fields for dcdc5
 and dcdc6
References: <1404884193-20580-2-git-send-email-j-keerthy@ti.com> <1404901379-30135-1-git-send-email-j-keerthy@ti.com> <20140710121210.GF30458@sirena.org.uk>
In-Reply-To: <20140710121210.GF30458@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2014 05:42 PM, Mark Brown wrote:
> On Wed, Jul 09, 2014 at 03:52:59PM +0530, Keerthy wrote:
>> Add fixed_uV fields for dcdc5 and dcdc6.
> Applied, but don't bury new patches into the middle of old threads -
> it's a good way to get your patch ignored.

Okay. I thought only one patch had to be redone on top of the other branch
so did it this way. I will resend a new series next time onwards. Thanks.

Regards,
Keerthy
