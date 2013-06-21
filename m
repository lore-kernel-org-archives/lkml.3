Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423347Ab3FUQY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:24:59 -0400
Received: from 8bytes.org ([85.214.48.195]:37163 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422679Ab3FUQY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:24:58 -0400
Date: Fri, 21 Jun 2013 18:24:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu/amd: IOMMU Error Reporting/Handling/Filtering
Message-ID: <20130621162455.GN11309@8bytes.org>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130621151459.GK11309@8bytes.org>
 <20130621155933.GA24385@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621155933.GA24385@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 21 18:24:57 2013
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c47e5920862076023326
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 05:59:33PM +0200, Borislav Petkov wrote:
> On Fri, Jun 21, 2013 at 05:15:00PM +0200, Joerg Roedel wrote:
> > Instead of extending this bad scaling dmesg error-reporting mechanism,
> > I would very much like to see an integration of IOMMU error handling
> > into the EDAC framework.
> 
> Wouldn't just adding a tracepoint and collecting the logs in debugfs be
> enough? This would at least avoid spamming syslog with the messages.

I would rather not create another user-space interface for this which we
then have to keep forever because someone started using it. What we need
is a well defined mechanism to report these kernel metrics to userspace
which can then do with it whatever it wants. I think EDAC can provide
that interface.


	Joerg


