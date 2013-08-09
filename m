Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab3HIQIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:08:05 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:45331 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3HIQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:08:03 -0400
Date: Fri, 9 Aug 2013 12:07:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v3 1/5] sata, highbank: fix ordering of SGPIO signals
Message-ID: <20130809160756.GO20515@mtj.dyndns.org>
References: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 10:52:34AM -0500, Mark Langsdorf wrote:
> The ACTIVITY and ERROR signals were reversed in the original commit.
> Fix that so that hard drive activity does not show up on the error
> light, and attempts to indicate that the hard drive is failing do
> not show up as hard drive activity. This fixes a fairly serious
> functional bug in the driver, but failing to apply this patch will
> not cause any stability issues on the system.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>

Applied to libata/for-3.11-fixes w/ stable cc'd.

Thanks.

-- 
tejun
