Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaGUXM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:12:58 -0400
Received: from plane.gmane.org ([80.91.229.3]:48630 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaGUXM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:12:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthew Longnecker <mlongnecker@nvidia.com>
Subject: Re: [PATCH 4/6] ARM: tegra: Add soctherm and thermal zones to Tegra124
 device tree
Date: Mon, 21 Jul 2014 16:12:41 -0700
Message-ID: <53CD9E69.4000309@nvidia.com>
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-5-git-send-email-mperttunen@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: searspoint.nvidia.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
In-Reply-To: <1403856699-2140-5-git-send-email-mperttunen@nvidia.com>
Cc: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/2014 1:11 AM, Mikko Perttunen wrote:
> This adds the soctherm thermal sensing and management unit to the
> Tegra124 device tree along with the four thermal zones it exports.

Mikko, soctherm doesn't "export thermal zones". I would rewrite your 
desription like this:

   Extend the Tegra124 device tree by adding the soctherm thermal
   sensing and management unit and by defining four thermal zones --
   one for each temperature sensor in soctherm.

System integrators have some flexibility in deciding how many thermal 
zones to define for their platform. For example, an integrator could 
define a single zone for the entire Tegra chip (giving a simple system 
at runtime) or with multiple zones (giving potentially higher 
performance near thermal limits). That's why I don't like the 
implication that soctherm dictates the existence of particular thermal 
zones.

-Matt

