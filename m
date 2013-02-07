Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab3BGVCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:02:41 -0500
Received: from 8bytes.org ([85.214.48.195]:39925 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab3BGVCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:02:40 -0500
Date: Thu, 7 Feb 2013 22:02:36 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Hannes Reinecke <hare@suse.de>
Cc: iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmar: Zero out memory
Message-ID: <20130207210235.GD2849@8bytes.org>
References: <1360140610-48309-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360140610-48309-1-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Feb  7 22:02:38 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5114166e22971795285947
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:50:10AM +0100, Hannes Reinecke wrote:
> kmemcheck complained about the use of uninitialized memory.
> So there.
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Applied to x86/vt-d, thanks Hannes.


