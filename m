Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab3BSSjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:39:41 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46436 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3BSSjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:39:39 -0500
Message-ID: <5123C6E7.9070407@wwwdotorg.org>
Date: Tue, 19 Feb 2013 11:39:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Joseph Lo <josephl@nvidia.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/12] Tegra114 clockframework
References: <1360931849-7090-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1360931849-7090-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 05:36 AM, Peter De Schrijver wrote:
> This is the seventh version of the Tegra114 clockframework. It is based on the
> for-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git and
> http://www.spinics.net/lists/arm-kernel/msg220452.html.

Mike,

I think it'd be prudent to take this series through the Tegra tree again
for 3.10; patch 11 needs to go in as part of the series due to internal
dependencies, and I'm slightly worried that other Tegra DT changes might
conflict with that patch (if only for context). Taking this series (and
any other Tegra clk driver changes for 3.10) through the Tegra tree
could resolve that easily. Do you have a problem with that?

If that's OK, can you stage the dependency Peter mentioned:
http://www.spinics.net/lists/arm-kernel/msg220452.html
into a stable branch for me to merge, obviously after 3.9-rc1 is out.

Thanks.

Prashant, could you provide a review/ack for this series too.

