Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423210Ab3FUP7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:59:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40104 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422824Ab3FUP7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:59:44 -0400
Date: Fri, 21 Jun 2013 17:59:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu/amd: IOMMU Error Reporting/Handling/Filtering
Message-ID: <20130621155933.GA24385@pd.tnic>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130621151459.GK11309@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130621151459.GK11309@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 05:15:00PM +0200, Joerg Roedel wrote:
> Instead of extending this bad scaling dmesg error-reporting mechanism,
> I would very much like to see an integration of IOMMU error handling
> into the EDAC framework.

Wouldn't just adding a tracepoint and collecting the logs in debugfs be
enough? This would at least avoid spamming syslog with the messages.

More sophisticated error handling can be done later...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
