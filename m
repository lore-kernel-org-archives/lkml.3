Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaI3Sp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:45:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:41305 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaI3Spz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:45:55 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        broonie@kernel.org, lee.jones@linaro.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com
Subject: Re: [PATCH v2 0/4] ARM: dts: apq8064 DT patches
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1412086159-20894-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Tue, 30 Sep 2014 11:45:52 -0700
In-Reply-To: <1412086159-20894-1-git-send-email-srinivas.kandagatla@linaro.org>
	(Srinivas Kandagatla's message of "Tue, 30 Sep 2014 15:09:19 +0100")
Message-ID: <7hvbo5vten.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srinivas Kandagatla <srinivas.kandagatla@linaro.org> writes:

> These patches adds dt nodes for RPM, USB and SATA IPs found in APQ8064.
> All the driver support for these IPs are already available in v3.17, except
> the RPM driver which is now accepted by Lee and Mark.
>
> These patches depend on the header file from 
> http://www.spinics.net/lists/arm-kernel/msg364310.html
> for regulators.
>
> Now that the RPM patch is accepted, should RPM patch go via arm-soc tree?
> so that we can get more functionality on IFC6410 board in v3.18 mainline.
>
> All these patches are tested on IFC6410 board.
> Am hoping to get these patches for v3.18, as these patches were sitting in
> my dev tree since last 3 merge windows.

A nit on process, for future reference:

You only need to send to arm@kernel.org if you're expecting the arm-soc
maintainers to directly apply the patches or pull request.

In this case, it seems like stuff that the qcom maintainers will queue
up in their DT branch, and then submit to arm-soc maintainers.

Kevin
