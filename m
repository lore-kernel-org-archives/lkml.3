Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaBKRc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:32:28 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41285 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751084AbaBKRc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:32:27 -0500
Message-ID: <1392139946.3380.48.camel@hornet>
Subject: Re: [PATCH 08/12] mfd: vexpress-sysreg: Add syscon labels as
 platform data
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 11 Feb 2014 17:32:26 +0000
In-Reply-To: <20140211172918.GH15081@lee--X1>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <1392138636-29240-9-git-send-email-pawel.moll@arm.com>
	 <20140211172918.GH15081@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 17:29 +0000, Lee Jones wrote:
> There must be better
> ways of passing a name than through pdata, and if there isn't I'd
> suggest setting up a sysconf pdata struct that others can use in case
> they wish to expand the functionality further in some other
> unfathomable way. :)

... which I proposed in the previous patch :-)

On Tue, 2014-02-11 at 17:10 +0000, Pawel Moll wrote:
> Alternatively I could define a syscon platform data structure,
> something like this:
> 
> struct syscon_platform_data {
> 	const char *label;
> };

Pawel

