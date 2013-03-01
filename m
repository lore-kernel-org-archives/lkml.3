Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3CATep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:34:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44757 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3CATeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:34:44 -0500
Message-ID: <513102D0.5030609@wwwdotorg.org>
Date: Fri, 01 Mar 2013 12:34:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: palmas: provide irq flags through DT/platform data
References: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com> <20130301124350.GA25302@opensource.wolfsonmicro.com> <5130A53C.1000600@nvidia.com> <20130301131633.GB25302@opensource.wolfsonmicro.com>
In-Reply-To: <20130301131633.GB25302@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 06:16 AM, Mark Brown wrote:
> On Fri, Mar 01, 2013 at 06:25:24PM +0530, Laxman Dewangan wrote:
>> On Friday 01 March 2013 06:13 PM, Mark Brown wrote:
> 
>>> This can't be a generic problem on ARM systems, I'm pretty sure
>>> the primary users of palmas would've noticed, this is more of a
>>> new feature isn't it?
> 
>> I think it is tested with eval board and connected to gpio
>> interrupt and hence it is not noticed.
> 
> One of the palmas chips is the default PMIC for OMAP5 isn't it?

A tangential question more re: DT bindings for it:

Is Palmas a family of chips rather than a single chip then? That
implies that the DT would need two compatible values, e.g.:

compatible = "ti,12345", "ti,palmas";

... where "12345" is the actual chip name.

... rather than just the following which IIRC was in the example in
the DT binding document in another patch series:

compatible = "ti,palmas";
