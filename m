Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3HLQaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:30:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58443 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab3HLQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:30:37 -0400
Message-ID: <52090DAC.3050407@codeaurora.org>
Date: Mon, 12 Aug 2013 09:30:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Subject: Re: [PATCH] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex
 block
References: <1375128719-23642-1-git-send-email-galak@codeaurora.org> <E9700EA7-7154-46C5-9258-03F030DF69F6@codeaurora.org> <20130729214035.GC8868@codeaurora.org> <9EB1A821-7137-4812-B58A-20F669BCA7DD@codeaurora.org> <0A09DA0F-86B4-4961-88E2-64FA0A4D380D@codeaurora.org> <CAK=WgbZSJmMz_U56ZsppBrB64XvTHBqJM4L+uFY1kKxhMCCtMQ@mail.gmail.com>
In-Reply-To: <CAK=WgbZSJmMz_U56ZsppBrB64XvTHBqJM4L+uFY1kKxhMCCtMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/13 12:11, Ohad Ben-Cohen wrote:
> Otherwise, Stephen - do we have your Ack here? I was happy to see your
> review but not sure what's the latest status.

The smp_mb() should be removed. Otherwise I'm willing to accept that we
only build this driver on ARCH_MSM for now. We can fix that in the
future to be available to hexagon if they ever want it. After that it
just needs a DT review/ack so I'll be happy to add a reviewed-by on v3.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

