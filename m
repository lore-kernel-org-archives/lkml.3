Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3DSTNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:13:45 -0400
Received: from 8bytes.org ([85.214.48.195]:50911 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab3DSTNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:13:44 -0400
Date: Fri, 19 Apr 2013 21:13:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Wang YanQing <udknight@gmail.com>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Subject: Re: [PATCH] iommu: Include linux/err.h
Message-ID: <20130419191339.GA19345@8bytes.org>
References: <20130419013804.GA7552@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130419013804.GA7552@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Apr 19 21:13:42 2013
X-DSPAM-Confidence: 0.9951
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5171976623671800315502
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 09:38:04AM +0800, Wang YanQing wrote:
> The linux/iommu.h header uses ERR_PTR defined
> in linux/err.h but doesn't include it.
> 
> Cc:joro@8bytes.org
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Applied to core branch, thanks.


