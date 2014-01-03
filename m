Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaACB1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:27:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51472 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaACB1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:27:16 -0500
Message-ID: <52C611F3.8090306@codeaurora.org>
Date: Thu, 02 Jan 2014 17:27:15 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 06/10] Input: pm8xxx-vibrator - Add DT match table
References: <1388709460-19222-1-git-send-email-sboyd@codeaurora.org> <1388709460-19222-7-git-send-email-sboyd@codeaurora.org> <20140103011722.GA9300@core.coreip.homeip.net>
In-Reply-To: <20140103011722.GA9300@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/14 17:17, Dmitry Torokhov wrote:
> Hi Stephen,
>
> On Thu, Jan 02, 2014 at 04:37:36PM -0800, Stephen Boyd wrote:
>> The driver is only supported on DT enabled platforms. Convert the
>> driver to DT so that it can probe properly.
> I do not see MFD_PM8XXX depending on OF, should it be added if it only
> supported on DT?

No that would unnecessarily limit the compile coverage of this driver.
This one is so simple that it doesn't even use any OF APIs because it is
all hidden behind the platform bus.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

