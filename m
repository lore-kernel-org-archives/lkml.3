Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaDYQNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:13:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41885 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaDYQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:13:21 -0400
Message-ID: <535A899E.5020801@codeaurora.org>
Date: Fri, 25 Apr 2014 11:13:18 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org> <5357A80B.8030701@linux.intel.com> <5357ACF1.9070206@codeaurora.org> <20140423135915.GY30677@intel.com> <5357D8CC.3080501@codeaurora.org> <20140424063546.GA30677@intel.com> <5358F30E.9080402@codeaurora.org> <20140424115848.GG30677@intel.com> <53592D04.4040001@codeaurora.org> <20140425074156.GI30677@intel.com>
In-Reply-To: <20140425074156.GI30677@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Westerberg, Mika wrote:
> If you happen to have pin controller/mux driver that drives that hardware,
> I'm sure your pinmux functions gets called.

Actually, I don't think they do.  On a device-tree system, the functions 
get called automatically by the pinctrl layer when it parses the device 
tree.  This happens in response to probe, remove, and various power 
management changes.

AFAIK, there is nothing at all like that for ACPI systems.  Do you have 
an example of a driver making pinmux calls directly?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
