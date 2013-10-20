Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3JTVbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:31:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57443 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3JTVbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:31:53 -0400
Message-ID: <52644BBF.2050704@wwwdotorg.org>
Date: Sun, 20 Oct 2013 22:31:43 +0100
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/15] ARM: tegra30: add missing CLK IDs
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com> <1382102719-5531-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1382102719-5531-2-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 02:25 PM, Peter De Schrijver wrote:
> The Tegra30 clock bindings lack few IDs for audio and clk_out muxes.

Is there a list of changes for V5?

Don't forget that I gave tested-by/acked-by for V4(?), unless you've
changed so much you consider that to no longer apply?
