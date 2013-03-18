Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3CRPBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:01:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:38455 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab3CRPBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:01:42 -0400
Subject: Re: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu implementation.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D40ABB4@039-SN2MPN1-013.039d.mgd.msft.net>
Date: Mon, 18 Mar 2013 09:59:53 -0500
Cc: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CCCE947A-1C24-40C2-9341-BBF3F5C00D98@kernel.crashing.org>
References: <1363200580-11623-1-git-send-email-Varun.Sethi@freescale.com> <0080B56D-8417-41B9-8341-665457D04DE6@kernel.crashing.org> <C5ECD7A89D1DC44195F34B25E172658D40ABB4@039-SN2MPN1-013.039d.mgd.msft.net>
To: Sethi Varun-B16395 <B16395@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 17, 2013, at 10:48 AM, Sethi Varun-B16395 wrote:

>>> 
>>> +	guts_node = of_find_compatible_node(NULL, NULL,
>>> +			"fsl,qoriq-device-config-1.0");
>> 
>> This doesn't work for T4 or B4 device trees.
>> 
> [Sethi Varun-B16395]hmm.... I need to use the dcfg space for this.

Let's see with the SoC arch's if something like "fsl,qoriq-device-config-2.0" makes sense for T4 & B4.

- k