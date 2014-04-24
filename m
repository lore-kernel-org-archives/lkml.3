Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbaDXLUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:20:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57583 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaDXLUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:20:03 -0400
Message-ID: <5358F362.6080006@codeaurora.org>
Date: Thu, 24 Apr 2014 06:20:02 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: "Westerberg, Mika" <mika.westerberg@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com> <534B93BA.6020406@linux.intel.com> <534BFAAF.3070805@codeaurora.org> <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org> <5357A80B.8030701@linux.intel.com> <5357ACF1.9070206@codeaurora.org> <20140423135915.GY30677@intel.com> <5357D8CC.3080501@codeaurora.org> <CACRpkdbk8okbzaZgD=BqeMSOvbEvYNViqamd9i=NAaAWW=T9sQ@mail.gmail.com> <20140424062719.GZ30677@intel.com>
In-Reply-To: <20140424062719.GZ30677@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Westerberg, Mika wrote:
> Typically this is done by the boot firmware (BIOS in this case). So the OS
> doesn't need to deal with that.
>
> AFAICT ACPI doesn't know anything about pin muxing.

In that case, would it be correct to say that a Linux pinctrl driver for 
an ACPI-only platform should not define pinmux function groups, because 
they'll never be used?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
