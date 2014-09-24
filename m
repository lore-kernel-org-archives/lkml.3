Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaIXNus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:50:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41147 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbaIXNum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:50:42 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v7 3/3] regulator: qcom-rpm: Regulator driver for the Qualcomm RPM
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140924083518.GB4015@sirena.org.uk>
Date: Wed, 24 Sep 2014 08:50:38 -0500
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4437DA50-D8BC-4E78-821C-41440A08B9A9@codeaurora.org>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com> <1411428329-23172-4-git-send-email-bjorn.andersson@sonymobile.com> <20140924083518.GB4015@sirena.org.uk>
To: Mark Brown <broonie@kernel.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24, 2014, at 3:35 AM, Mark Brown <broonie@kernel.org> wrote:

> On Mon, Sep 22, 2014 at 04:25:29PM -0700, Bjorn Andersson wrote:
>> Driver for regulators exposed by the Resource Power Manager (RPM) found
>> in Qualcomm 8660, 8960 and 8064 based devices.
> 
> Applied, thanks.

Mark, can you drop this until we see at least an RFC patch for the RPM support for b-family SoCs (8074, 8084, etc) chips.  The regulator could should either be the same or highly similar for b-family, but until we see the core RPM driver on the b-family SoCs we will not know that.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

