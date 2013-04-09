Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab3DITwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:52:35 -0400
Received: from 8bytes.org ([85.214.48.195]:36355 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817Ab3DITwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:52:34 -0400
Date: Tue, 9 Apr 2013 21:52:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130409195231.GI6858@8bytes.org>
References: <1364947610-3327-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130409094132.GD6858@8bytes.org>
 <51642FCD.8080606@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51642FCD.8080606@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 21:52:32 2013
X-DSPAM-Confidence: 0.9983
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164718023671768114554
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 10:12:13AM -0500, Suthikulpanit, Suravee wrote:
> These messages are not "high volumn".  What I am trying to achieve
> is for users to be able to just send the errors to developers once
> they are encountered without having to tell them to go back and
> reboot with the "amd_iommu=verbose". In facts, they often difficult
> to reproduce from my experience.  This should reduce the amount of
> communications and efforts required to debug the issue.

More than one line per io-page-fault _is_ high volume. The current code
that prints only one line was sufficient to debug all related AMD IOMMU
driver problems in the past 5 years I am working on this driver.

What makes sense is decoding the flags field in the kernel. Doing this
by hand always costs some time that could be saved this way. If your
patch does more than that by default I am not going to merge it.


	Joerg


