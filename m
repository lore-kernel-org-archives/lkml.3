Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab3HNUoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:44:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65464 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124Ab3HNUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:44:07 -0400
Date: Wed, 14 Aug 2013 16:44:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v4 1/3] devicetree: create a separate binding description
 for sata_highbank
Message-ID: <20130814204402.GM28628@htj.dyndns.org>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
 <1376512811-25428-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376512811-25428-1-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 03:40:11PM -0500, Mark Langsdorf wrote:
> The Calxeda sata_highbank driver has been adding its descriptions to the
> ahci driver. Separate them properly. This patch only affects
> documentation and has no functional component.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Applied 1-3 to libata/for-3.12.

Thanks.

-- 
tejun
