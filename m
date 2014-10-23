Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaJWHaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:30:16 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:37613 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaJWHaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:30:13 -0400
MIME-Version: 1.0
In-Reply-To: <20141022155058.GN4939@x1>
References: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
	<CABgxDoKus_D=ooCz3TqyXP9CTJUgbZVxQSsw4ZgBx1oYaTefbw@mail.gmail.com>
	<20141022155058.GN4939@x1>
Date: Thu, 23 Oct 2014 09:30:12 +0200
Message-ID: <CABgxDoJSLrAOMMA7=ZGd4F6z7_FkojCdjUNi52wbocZk7yJowQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] mfd: tps65910: Convert ti,system-power-controller
 DT property to poweroff-source
From: PERIER Romain <romain.perier@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, robh+dt@kernel.org,
        "pawel.moll" <pawel.moll@arm.com>, mark.rutland@arm.com,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        galak <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        swarren <swarren@wwwdotorg.org>,
        "thierry.reding" <thierry.reding@gmail.com>, gnurou <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-22 17:50 GMT+02:00 Lee Jones <lee.jones@linaro.org>:
> On Wed, 22 Oct 2014, PERIER Romain wrote:
>
>> This is related to the following subject "[RFC v3 PATCH 1/5] of: Add
>> standard property for poweroff capability" and depends on the
>> corresponding patch.
>
> Then it should be sent in the same patch-set.
>
> There's nothing I can do with this patch as is.
>

Even if this patch is already commited and present in "linux-next" ?
(or in Mark Brown's regulator tree)

Romain
