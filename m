Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaISWXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:23:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59081 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbaISWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:23:42 -0400
Message-ID: <541CACEC.90407@codeaurora.org>
Date: Fri, 19 Sep 2014 15:23:40 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v4 03/11] drivers: base: add cpu_device_create to support
 per-cpu devices
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com> <1409763617-17074-4-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1409763617-17074-4-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/14 10:00, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
>
> This patch adds a new function to create per-cpu devices.
> This helps in:
> 1. reusing the device infrastructure to create any cpu related
>    attributes and corresponding sysfs instead of creating and
>    dealing with raw kobjects directly
> 2. retaining the legacy path(/sys/devices/system/cpu/..) to support
>    existing sysfs ABI
> 3. avoiding to create links in the bus directory pointing to the
>    device as there would be per-cpu instance of these devices with
>    the same name since dev->bus is not populated to cpu_sysbus on
>    purpose
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: Kay Sievers <kay@vrfy.org>
>

Tested-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

