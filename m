Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaAILEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:04:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56096 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaAILEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:04:04 -0500
Date: Thu, 9 Jan 2014 12:03:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 3/6] ARM: Add Krait L2 accessor functions
Message-ID: <20140109110358.GB11594@pd.tnic>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
 <1388434457-4194-4-git-send-email-sboyd@codeaurora.org>
 <20140109005332.GB23276@sonymobile.com>
 <52CE0154.4030803@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52CE0154.4030803@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 05:54:28PM -0800, Stephen Boyd wrote:
> Ok. Borislav, should I resend to add krait_ before these functions?

Yes please - I can't even build-test here so I'm relying on you.

That's why I thought it might be a better idea for this purely arm patch
to go through some other tree where it sees some build-testing at least.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
