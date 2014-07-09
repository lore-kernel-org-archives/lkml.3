Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaGIDqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:46:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37097 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaGIDqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:46:32 -0400
Message-ID: <53BCB9A6.7000500@ti.com>
Date: Wed, 9 Jul 2014 09:10:22 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>
Subject: Re: [PATCH v2 6/7] regulator: tps65218: Add get_voltage ops for dcdc5
 and dcdc6
References: <1404814597-4404-1-git-send-email-j-keerthy@ti.com> <1404814597-4404-7-git-send-email-j-keerthy@ti.com> <20140708141126.GW30458@sirena.org.uk>
In-Reply-To: <20140708141126.GW30458@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2014 07:41 PM, Mark Brown wrote:
> On Tue, Jul 08, 2014 at 03:46:36PM +0530, Keerthy wrote:
>
>> +static int tps65218_pmic_dcdc56_get_voltage(struct regulator_dev *dev)
>> +{
>> +	struct tps65218 *tps = rdev_get_drvdata(dev);
>> +	unsigned int rid = rdev_get_id(dev);
>> +
>> +	return tps->info[rid]->min_uV;
>> +}
> Set fixed_uV in the descriptor.
Okay. I will do that. Thanks for the review.

Regards,
Keerthy
