Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389Ab3HIQI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:08:58 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:36133 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806Ab3HIQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:08:56 -0400
Date: Fri, 9 Aug 2013 12:08:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v3 2/5] sata highbank: enable 64-bit DMA mask when using
 LPAE
Message-ID: <20130809160850.GP20515@mtj.dyndns.org>
References: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
 <1375890758-30265-2-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375890758-30265-2-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 10:52:35AM -0500, Mark Langsdorf wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>

Applied to libata/for-3.12.

Thanks.

-- 
tejun
