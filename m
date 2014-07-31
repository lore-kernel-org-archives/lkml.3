Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaGaUZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:25:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49582 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaGaUZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:25:49 -0400
Message-ID: <53DAA64B.6040203@codeaurora.org>
Date: Thu, 31 Jul 2014 13:25:47 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4 0/5] Simplify hotplug/suspend handling
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org> <1667655.2j1xLy7HXa@vostro.rjw.lan>
In-Reply-To: <1667655.2j1xLy7HXa@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 05:29 PM, Rafael J. Wysocki wrote:
> On Thursday, July 24, 2014 06:07:23 PM Saravana Kannan wrote:
>> Series of patchs to simplify policy/sysfs/kobj/locking handling across
>> suspend/resume
>
> I need someone to review this series for me.  Viresh or Srivatsa, preferably
> both.

Viresh/Srivatsa,

Bump. Can you guys please review this?

-Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
