Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3A2IvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:51:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab3A2IvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:51:08 -0500
Message-ID: <51078D73.9010409@suse.cz>
Date: Tue, 29 Jan 2013 09:50:59 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <glikely@secretlab.ca>, Sam Ravnborg <sam@ravnborg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V7 REPOST] kbuild: create a rule to run the pre-processor
 on *.dts files
References: <1359419600-7967-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1359419600-7967-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.1.2013 01:33, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Create cmd_dtc_cpp to run the C pre-processor on *.dts file before
> passing them to dtc for final compilation. This allows the use of #define
> and #include within the .dts file.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Simon Glass <sjg@chromium.org>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---
> Grant, back in mid-November, you said you'd make a decision on this in
> the next couple of days, but I think this got overlooked.

You can add Acked-by: Michal Marek <mmarek@suse.cz>. Or I can add it to
the kbuild tree if Grant is OK with the patch.

Michal
