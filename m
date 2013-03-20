Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab3CTPmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:42:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60654 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab3CTPmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:42:04 -0400
Date: Wed, 20 Mar 2013 16:42:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rob Edwards <RAEdwards@insightbb.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD A6 3650 getting Kernel Panics in Ubuntu 12.10
Message-ID: <20130320154200.GB15562@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Rob Edwards <RAEdwards@insightbb.com>, linux-kernel@vger.kernel.org
References: <019e01ce257d$20f01df0$62d059d0$@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <019e01ce257d$20f01df0$62d059d0$@insightbb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:10:58AM -0400, Rob Edwards wrote:
> I posted a question at
> http://www.dslreports.com/forum/r28112391-AMD-A6-3650-getting-Kernel-Panics-
> in-Ubuntu-12.10-  looking for help with my Ubuntu machine and some strange
> kernel panics I have been getting and was directed here.  I cant run them
> through the mcelog as it says the CPU is unknown.  (Too new I guess)?  I
> wont paste the contents of the logs in the email (its at the url I
> provided) unless asked too.  Does anyone know what I should be looking at
> for the problem?

Can you modprobe edac_mce_amd.ko and try to catch dmesg when those
errors happen again? You don't need mcelog on AMD - the decoded MCEs are
already in the kernel log.

Btw, what kernel is Ubuntu 12.10?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
