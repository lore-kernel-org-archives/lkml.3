Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaDXLSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:18:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57443 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaDXLSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:18:40 -0400
Message-ID: <5358F30E.9080402@codeaurora.org>
Date: Thu, 24 Apr 2014 06:18:38 -0500
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
References: <1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com> <534B93BA.6020406@linux.intel.com> <534BFAAF.3070805@codeaurora.org> <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org> <5357A80B.8030701@linux.intel.com> <5357ACF1.9070206@codeaurora.org> <20140423135915.GY30677@intel.com> <5357D8CC.3080501@codeaurora.org> <20140424063546.GA30677@intel.com>
In-Reply-To: <20140424063546.GA30677@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Westerberg, Mika wrote:
>> >That is, when the kernel parses the ASL, and it seems a command to
>> >configure pin #3 to function #4, it calls the local pinctrl driver to do
>> >that?

> I'm not aware of ASL code that allows you to do that. Do you have examples?

No, that's my point.  I was expecting the pinmux functions of the 
pinctrl driver are used by ACPI, but apparently they aren't, and that's 
why I'm asking.  I'm wondering why a pinctrl driver for an ACPI platform 
should be defining pinmux function groups.  I haven't gotten a straight 
answer to that question.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
