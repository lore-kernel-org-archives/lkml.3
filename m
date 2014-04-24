Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbaDXP0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:26:02 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52901 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaDXPZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:25:59 -0400
Message-ID: <53592D04.4040001@codeaurora.org>
Date: Thu, 24 Apr 2014 10:25:56 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <534B93BA.6020406@linux.intel.com> <534BFAAF.3070805@codeaurora.org> <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org> <5357A80B.8030701@linux.intel.com> <5357ACF1.9070206@codeaurora.org> <20140423135915.GY30677@intel.com> <5357D8CC.3080501@codeaurora.org> <20140424063546.GA30677@intel.com> <5358F30E.9080402@codeaurora.org> <20140424115848.GG30677@intel.com>
In-Reply-To: <20140424115848.GG30677@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 06:58 AM, Westerberg, Mika wrote:
>> >No, that's my point.  I was expecting the pinmux functions of the
>> >pinctrl driver are used by ACPI, but apparently they aren't, and
>> >that's why I'm asking.

> Which functions?

The functions in struct pinmux_ops, like get_function_groups.  Will 
these functions ever be called on an ACPI system?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by the Linux Foundation.
