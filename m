Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3CKRfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:35:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60671 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3CKRfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:35:40 -0400
Message-ID: <513E15E9.8090904@wwwdotorg.org>
Date: Mon, 11 Mar 2013 11:35:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 2/5] ARM: DT: tegra114: Add i2c controller DT entry
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com> <1362852678-13421-3-git-send-email-ldewangan@nvidia.com> <20130310223936.GF4743@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130310223936.GF4743@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 04:39 PM, Thierry Reding wrote:
> On Sat, Mar 09, 2013 at 11:41:15PM +0530, Laxman Dewangan wrote:
>> NVIDIA's Tegra114 has 5 i2c controllers. These controllers have 
>> additional feature/configurations to make it functional over 
>> Tegra30's i2c controller driver.
>> 
>> Add DT entry for i2c controllers and make it compatible with 
>> "nvidia,tegra114-i2c".
> 
> Both the subject and description should probably use I2C instead of
> i2c. Also I don't understand what "make it functional over" means.
> Perhaps, since the entries aren't marked compatible with
> nvidia,tegra30-i2c you meant to say that they are incompatible with
> Tegra30?

The second sentence Laxman wrote above should probably say:

These controllers have a modified clocking structure that make them
incompatible with previous hardware.

