Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab3HNQym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:54:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39852 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3HNQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:54:40 -0400
Date: Wed, 14 Aug 2013 17:54:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] intel_ips: blacklist ASUSTek G60JX laptops
Message-ID: <20130814165433.GA23188@srcf.ucam.org>
References: <cover.1376494861.git.joseph.salisbury@canonical.com>
 <d4635f76028172e872cc4be506bad1c11816f75a.1376494861.git.joseph.salisbury@canonical.com>
 <20130814093836.57002b77@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814093836.57002b77@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:38:36AM -0700, Jesse Barnes wrote:

> Linus, you may want to pick this up directly, as I'm not sure if
> Matthew is still looking after the x86 drivers these days.

I am, but I'm not keen on this patch. Which is more likely - that the ME 
is hung, or that it was never working on this in the first place? Is 
there really no bit to indicate whether or not the platform supports the 
feature?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
