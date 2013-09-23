Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3IWVgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:36:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36300 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3IWVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:36:40 -0400
Message-ID: <5240B464.2010903@wwwdotorg.org>
Date: Mon, 23 Sep 2013 15:36:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mfd: arizona: Add device tree helper functions
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-Reply-To: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 12:30 PM, Charles Keepax wrote:
> Factor out reading of specific device tree bindings into seperate
> functions in preperation for adding more of them. Whilst we are at is
> fixup a couple of small issues in the existing binding documentation.

> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt

> -  - AVDD1-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
> +  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,

That looks like an incompatible change to the DT ABI.
