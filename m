Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbaCOPfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:35:31 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60375 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaCOPf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:35:29 -0400
Message-ID: <5324737B.5010804@kernel.org>
Date: Sat, 15 Mar 2014 15:36:27 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Marek Belisko <marek@goldelico.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv3 1/9] mfd: twl4030-madc: Use managed resources
References: <1394472329-15485-1-git-send-email-sre@debian.org> <1394472329-15485-2-git-send-email-sre@debian.org>
In-Reply-To: <1394472329-15485-2-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/14 17:25, Sebastian Reichel wrote:
> Update twl4030-madc driver to use managed resources.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Tested-by: Marek Belisko <marek@goldelico.com>
My email client was having a crazy day and not showing me this revision of the
patches - I'll bring my comments across so they don't get lost.

Acked-by: Jonathan Cameron <jic23@kernel.org>


