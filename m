Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3JYIhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:37:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54709 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3JYIhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:37:13 -0400
Subject: Re: [PATCHv2] iio:light:tsl2563: Add DT support
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131025082344.GA6425@earth.universe>
Date: Fri, 25 Oct 2013 03:37:22 -0500
Cc: linux-iio@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <915C1A7A-6128-4B8B-A594-F2CDDED201DC@codeaurora.org>
References: <1382565063-17083-1-git-send-email-sre@debian.org> <1382624835-10228-1-git-send-email-sre@debian.org> <35B50A0C-D1F9-4D87-86DD-951BF71F2903@codeaurora.org> <20131025082344.GA6425@earth.universe>
To: Sebastian Reichel <sre@debian.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 25, 2013, at 3:23 AM, Sebastian Reichel wrote:

> On Thu, Oct 24, 2013 at 10:32:36PM -0500, Kumar Gala wrote:
>> On Oct 24, 2013, at 9:27 AM, Sebastian Reichel wrote:
>>> Add Device Tree support for the TSL2563 driver
>>> and document the binding.
>>> 
>>> Signed-off-by: Sebastian Reichel <sre@debian.org>
>>> ---
>>> .../devicetree/bindings/iio/light/tsl2563.txt         | 19 +++++++++++++++++++
>>> Documentation/devicetree/bindings/vendor-prefixes.txt |  1 +
>>> drivers/iio/light/tsl2563.c                           |  4 ++++
>> 
>> For the Binding, assuming another patch to add amstoas to the vendor list
> 
> I embedded the vendor list update into this patch.
> Should I split this into its own patch?
> 
> -- Sebastian

Its fine, but do update the commit comment about that.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

