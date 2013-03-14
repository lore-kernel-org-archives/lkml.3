Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3CNMgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:36:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48225 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3CNMgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:36:44 -0400
Message-ID: <5141C44B.1000301@ti.com>
Date: Thu, 14 Mar 2013 18:06:27 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>
Subject: Re: [PATCH 1/3] arm: davinci: clock node support for ECAP & EHRPWM
References: <1363257453-24747-1-git-send-email-avinashphilip@ti.com> <1363257453-24747-2-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1363257453-24747-2-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 3/14/2013 4:07 PM, Philip Avinash wrote:
> Add clock node support for ECAP and EHRPWM modules.
> Also adds dummy clock for EHRWPM TBCLK to comply with pwm-tiehrpwm
> driver.

This is not right. So the version of IP used on AM335x uses a TBCLK and
that's absent on the version used on DA850? If yes, the driver should
never request clock on DA850.

Thanks,
Sekhar
