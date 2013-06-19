Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3FSRJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:09:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40294 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab3FSRI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:08:58 -0400
Message-ID: <51C1E5A5.9090105@wwwdotorg.org>
Date: Wed, 19 Jun 2013 11:08:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Keerthy <j-keerthy@ti.com>
CC: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        sameo@linux.intel.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Subject: Re: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com> <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 11:57 PM, Keerthy wrote:
> From: J Keerthy <j-keerthy@ti.com>
> 
> Check if irq value obtained is valid. If it is not valid
> then skip the irq request step and go ahead with the probe.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
