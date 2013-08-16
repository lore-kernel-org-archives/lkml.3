Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3HPWQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:16:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53187 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3HPWPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:15:02 -0400
Subject: Re: [PATCH RFC 3/3] spmi: document the PMIC arbiter SPMI bindings
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130816192549.GG4035@joshc.qualcomm.com>
Date: Fri, 16 Aug 2013 14:48:59 -0500
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A1FAB0A0-C205-4401-838C-B745B5B95FF3@codeaurora.org>
References: <cover.1376596224.git.joshc@codeaurora.org> <b639088d50df93caaef8fe7e09c12953b1153ce8.1376596224.git.joshc@codeaurora.org> <D1534646-7CB5-4EE7-8C1E-1C607BE22396@codeaurora.org> <20130816192549.GG4035@joshc.qualcomm.com>
To: Josh Cartwright <joshc@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 16, 2013, at 2:25 PM, Josh Cartwright wrote:

> Hey Kumar-
> 
> Thanks for the review.
> 
> On Fri, Aug 16, 2013 at 01:53:27PM -0500, Kumar Gala wrote:
>> On Aug 9, 2013, at 3:37 PM, Josh Cartwright wrote:
>> 
>>> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
>>> ---
>>> .../devicetree/bindings/spmi/spmi-pmic-arb.txt     | 26 ++++++++++++++++++++++
>>> 1 file changed, 26 insertions(+)
>>> create mode 100644 Documentation/devicetree/bindings/spmi/spmi-pmic-arb.txt
>> 
>> As this is a qcom specific binding, I think the file name should be msm-spmi-pmic-arb.txt or something like that.
> 
> Agreed.  It might be nice to use a vendor prefix in the name too.  How's qcom,msm-pmic-arb.txt sound?

Sounds good, as I see we have other examples of having a comma in file names for bindings.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

