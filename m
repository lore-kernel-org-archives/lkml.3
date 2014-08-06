Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaHFHfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:35:45 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13791 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaHFHfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:35:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 06 Aug 2014 00:26:57 -0700
Message-ID: <53E1DA60.9010401@nvidia.com>
Date: Wed, 6 Aug 2014 13:03:52 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: userspace-consumer: add DT binding details
References: <1406728440-17837-1-git-send-email-ldewangan@nvidia.com> <1406728440-17837-2-git-send-email-ldewangan@nvidia.com> <20140730155302.GE20162@leverpostej> <20140730164014.GY17528@sirena.org.uk>
In-Reply-To: <20140730164014.GY17528@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2014 10:10 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Jul 30, 2014 at 04:53:03PM +0100, Mark Rutland wrote:
>> On Wed, Jul 30, 2014 at 02:54:00PM +0100, Laxman Dewangan wrote:
>>> +Required properties:
>>> +- compatible		: Must be "reg-userspace-consumer".
>> I would never expect to see "userspace" in a DT beinding string; this is
>> entirely a software abstraction description and has nothing to do with
>> the interaction of HW components.
>> Why do you think we need this in the DT?
> Yes, this is test code - it is not intended to be used in production.
> Any binding should be for the consumer using this, not for this
> implementation detail.
>

We have the GPS module and its driver in the user space. There is no 
code for GPS on kernel. Just power on and open port from user space, get 
the information.

On this case, how do we power on GPS module if we don't expose it? It 
need two power source for digital section and analog section.
