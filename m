Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaC0BcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 21:32:04 -0400
Received: from void.printf.net ([89.145.121.20]:59774 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaC0BcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 21:32:01 -0400
From: Chris Ball <chris@printf.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Georgi Djakov <gdjakov@mm-sol.com>, linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v11 0/3] mmc: sdhci-msm: Add support for Qualcomm chipsets
References: <1394465833-22581-1-git-send-email-gdjakov@mm-sol.com>
	<53330387.7000803@mm-sol.com>
	<CAPDyKFqjjgWnH4Lt7vOPSM09ngvY1N6ustaBU41tZCJoKWrkzw@mail.gmail.com>
Date: Thu, 27 Mar 2014 01:31:42 +0000
In-Reply-To: <CAPDyKFqjjgWnH4Lt7vOPSM09ngvY1N6ustaBU41tZCJoKWrkzw@mail.gmail.com>
	(Ulf Hansson's message of "Thu, 27 Mar 2014 00:09:24 +0100")
Message-ID: <86eh1owhoh.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 26 2014, Ulf Hansson wrote:
> On 26 March 2014 17:42, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>> Hello Chris, Ulf,
>>
>> Do you have any comments on the patches?
>> The arch code that will use this driver is already in mainline. The
>> regulators support seem to be still on its way, but this driver also works
>> fine with dummy regulators.
>
> Looks good to me!
>
> For the complete patchset:
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Thanks Georgi and Ulf -- pushed all three patches to mmc-next for 3.15.

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
