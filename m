Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaBKRcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:32:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56046 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaBKRcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:32:41 -0500
Message-ID: <52FA5EB4.7080008@codeaurora.org>
Date: Tue, 11 Feb 2014 12:32:36 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, lm-sensors@lm-sensors.org, arm@kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 1/3] driver core & of: Mark of_nodes of added device as
 populated
References: <1392137610-27842-1-git-send-email-pawel.moll@arm.com> <1392137610-27842-2-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1392137610-27842-2-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On 02/11/2014 11:53 AM, Pawel Moll wrote:
> This patch tries to solve that issue in a generic way,
> adding a "populated" flag which is set in the device_node
> structure when a device is being created in the core.
> Later, of_platform_populate() skips such nodes (and
> its children) in a similar way to the non-available ones.

Will there never be a case where it is useful for a parent node to be created
early, but not necessarily the child nodes? Might only skipping nodes
explicitly marked as populated be a more universal solution?

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
