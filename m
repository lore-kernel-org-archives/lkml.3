Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3IXJB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:01:26 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48270 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3IXJBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:01:23 -0400
Date: Tue, 24 Sep 2013 18:00:59 +0900
From: takashi.yoshii.zj@renesas.com
To: Simon Horman <horms@verge.net.au>
Cc: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/6] ARM: shmobile: emev2: Define SMU clock DT bindings
Message-Id: <20130924180059.40485f1c9b841b04c3bb5f04@renesas.com>
In-Reply-To: <20130924045215.GE3619@verge.net.au>
References: <52410F86.4040301@renesas.com>
	<20130924131331.0e9a5f830f531655b2ea0ebe@ops.dti.ne.jp>
	<20130924045215.GE3619@verge.net.au>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,
# I had added wrong From:, sorry.

> With this in mind I believe the strings should be:
> 
> - renesas,smu-emev2
> - renesas,smu-clkdiv-emev2
> - renesas,smu-gclk-emev2

Thank you for pointed it out. I'll fix it in v2.

> To be honest I am not quite sure about the "-clkdiv" and "-gclk"
Neither am I.
I'm afread there are many 'not sure' thing for me about DT.
I know some part might be wrong, which does not follow ePAPR at least.
But, even I don't know whether I should follow ePAPR or not.

I will wait for response for a while.
/yoshii

