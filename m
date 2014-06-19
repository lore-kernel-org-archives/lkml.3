Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbaFSRLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:11:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35870 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbaFSRK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:10:58 -0400
Message-ID: <53A3199E.6030409@wwwdotorg.org>
Date: Thu, 19 Jun 2014 11:10:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alban Bedel <alban.bedel@avionic-design.de>,
        Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] ARM: tegra: tamonten: add the base board regulators
References: <1403184350-25403-1-git-send-email-alban.bedel@avionic-design.de>
In-Reply-To: <1403184350-25403-1-git-send-email-alban.bedel@avionic-design.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 07:25 AM, Alban Bedel wrote:
> Currently the Tamonten DTS define a fixed regulator for the 5V supply.
> However this regulator is in fact on the base board. Fix this by
> properly defining the regulators found on the base boards.

I've applied the series to Tegra's for-3.17/dt branch.
