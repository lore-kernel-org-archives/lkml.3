Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946776Ab3BHRQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:16:18 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51986 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946674Ab3BHRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:16:16 -0500
Message-ID: <511532DD.2080306@wwwdotorg.org>
Date: Fri, 08 Feb 2013 10:16:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: balbi@ti.com
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 08/10] ARM: dt: Add references to tegra_car clocks
References: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com> <1360330602-30472-9-git-send-email-pdeschrijver@nvidia.com> <20130208140301.GA23979@arwen.pp.htv.fi>
In-Reply-To: <20130208140301.GA23979@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 07:03 AM, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Feb 08, 2013 at 03:36:40PM +0200, Peter De Schrijver
> wrote:
>> tegra_car: clock { -		compatible = "nvidia,tegra114-car,
>> nvidia,tegra30-car"; +		compatible = "nvidia,tegra114-car";
> 
> trailing change or intentional ?

I believe it's intentional since the HW isn't fully
backwards-compatible. However, the commit description should mention this.
