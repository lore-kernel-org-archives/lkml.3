Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161614Ab3FURgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:36:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42718 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161490Ab3FURgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:36:36 -0400
Date: Fri, 21 Jun 2013 19:36:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu/amd: IOMMU Error Reporting/Handling/Filtering
Message-ID: <20130621173625.GH22006@pd.tnic>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130621151459.GK11309@8bytes.org>
 <20130621155933.GA24385@pd.tnic>
 <20130621162455.GN11309@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130621162455.GN11309@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 06:24:55PM +0200, Joerg Roedel wrote:
> I would rather not create another user-space interface for this which
> we then have to keep forever because someone started using it. What
> we need is a well defined mechanism to report these kernel metrics to
> userspace which can then do with it whatever it wants. I think EDAC
> can provide that interface.

What exactly do you think it should provide? A fast way to carry error
info to userspace (tracepoint) or some sort of error collection and
evaluation (need to do it yourself anyway - there's no such thing in
EDAC).

IOW, what specific functionality in EDAC are you actually thinking of?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
