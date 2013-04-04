Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765428Ab3DDX3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:29:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39593 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764564Ab3DDX3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:29:11 -0400
Message-ID: <515E0CC2.4060006@wwwdotorg.org>
Date: Thu, 04 Apr 2013 17:29:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <achew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/14] Tegra114 clockframework
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 08:40 AM, Peter De Schrijver wrote:
> This is the nineth version of the Tegra114 clockframework. It is based on the
> next-20130320-fixed branch of ...

I have applied this series to Tegra's for-3.10/clk branch, with patch
10/14 replaced by v9b.


