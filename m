Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3BOQnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:43:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54027 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3BOQnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:43:53 -0500
Message-ID: <511E65C5.7050107@wwwdotorg.org>
Date: Fri, 15 Feb 2013 09:43:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [v3 5/6] ARM: tegra114: create a DT header defining CLK IDs
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com> <1360917814-27236-6-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1360917814-27236-6-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 01:43 AM, Hiroshi Doyu wrote:
> To replace magic number in tegra_car:
> 
> -               clocks = <&tegra_car 28>;
> +               clocks = <&tegra_car CLK_HOST1X>;

Since the Tegra114-related files don't actually exist yet and hence
can't be applied, I think Peter should roll these patches into his
Tegra114 CCF series.

But perhaps hold off on that until Grant has a chance to ack/nak the
concept of doing this, and we've finalized on include path settings
etc., so there's no churn.
