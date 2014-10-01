Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaJASml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:42:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39971 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaJASmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:42:39 -0400
Date: Wed, 1 Oct 2014 20:42:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com, akpm@linux-foundation.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC: remove deprecated IRQF_DISABLED
Message-ID: <20141001184233.GH18271@pd.tnic>
References: <542BD4DC.40900@free-electrons.com>
 <1412159043-7348-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412159043-7348-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 12:24:03PM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Queued for 3.19,

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
