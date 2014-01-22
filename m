Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaAVLKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:10:21 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51351 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbaAVLKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:10:19 -0500
Date: Wed, 22 Jan 2014 11:09:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/5] arm: break part of __soft_restart out into
 separate function
Message-ID: <20140122110939.GE1621@mudshark.cambridge.arm.com>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-2-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389445524-30623-2-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 01:05:20PM +0000, Leif Lindholm wrote:
> Certain operations can be considered mandatory for any piece of code
> preparing to switch off the MMU. Break this out into separate function
> dmap_prepare().

idmap_prepare. dmap_prepare sounds like something *completely* different!

With that:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
