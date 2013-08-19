Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab3HSQo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:44:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46268 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3HSQo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:44:57 -0400
Message-ID: <52124B85.8080808@wwwdotorg.org>
Date: Mon, 19 Aug 2013 10:44:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: tegra: configure power off for Dalmore
References: <1376894028-30060-1-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1376894028-30060-1-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 12:33 AM, Bill Huang wrote:
> Add DT property to tell the regulator to register pm_power_off to make
> "shutdown" work.

Thanks. I've forwarded this to arm-soc for hopeful inclusion in 3.12,
since it was just a little late to get into the main set of pull
requests I sent.
