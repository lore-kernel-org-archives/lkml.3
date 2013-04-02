Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab3DBQGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:06:53 -0400
Received: from 8bytes.org ([85.214.48.195]:54014 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761234Ab3DBQGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:06:52 -0400
Date: Tue, 2 Apr 2013 18:06:50 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402160650.GQ30540@8bytes.org>
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130402143335.GB15687@8bytes.org>
 <20130402144037.GE5488@pd.tnic>
 <20130402150302.GF15687@8bytes.org>
 <20130402152956.GE4391@pd.tnic>
 <515AFC25.5060501@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515AFC25.5060501@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 18:06:51 2013
X-DSPAM-Confidence: 0.9985
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515b021b23671155412992
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 10:41:25AM -0500, Suthikulpanit, Suravee wrote:
> Turning this into WARN_ON() at this point might break a lot of
> systems currently out in the field.  However, users can always
> switching to use "intremap=off" but this might not be obvious.

A WARN_ON doesn't break systems, it just creates more noise. Probably
enough noise to get board vendors to fix their stuff up. But there is
more to consider before making more noise, of course :)


	Joerg


