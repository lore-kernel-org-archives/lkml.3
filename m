Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3EIOcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:32:07 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:42437 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3EIOcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:32:05 -0400
MIME-Version: 1.0
In-Reply-To: <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
	<1368076726-11492-2-git-send-email-skannan@codeaurora.org>
Date: Thu, 9 May 2013 22:32:04 +0800
Message-ID: <CACVXFVO3gPMXwzX0WUS4+-FA-SKEKnJt+aK4nL80aTAcEWNLPA@mail.gmail.com>
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
From: Ming Lei <tom.leiming@gmail.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:18 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> Kernel framework (Eg: regulator, clock, etc) might want to do some clean up
> work (Eg: turn off unclaimed resources) after all devices are done probing
> during kernel init. Before deferred probing was introduced, this was

Generally, system resources should be configured as disabled
at default, and for drivers, the correct usage should be only requesting
and enabling the resources just in need, then the sort of 'cleanup' things
can be avoided.


Thanks,
-- 
Ming Lei
