Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaHUSDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:03:46 -0400
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:43325 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaHUSDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:03:44 -0400
Date: Thu, 21 Aug 2014 21:03:29 +0300
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/4] Tegra124 soctherm driver
Message-ID: <20140821180329.GA5447@sandfort.unics.fi>
References: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com>
 <20140821122011.GA99564@sandfort.unics.fi>
 <20140821160127.GA17621@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821160127.GA17621@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 12:01:29PM -0400, Eduardo Valentin wrote:
> I suppose the 4 C to 5 C difference is not seen anymore in this version,
> right?

Yes, I verified that this newest version writes identical calibration
values to the CONFIG2 registers than the NVIDIA's internal downstream
driver and therefore the temperature difference is not seen anymore.
All the bugs I reported have been fixed in this version.
