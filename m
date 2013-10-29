Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3J2NRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:17:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44911 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab3J2NRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:17:16 -0400
Date: Tue, 29 Oct 2013 14:17:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: linux-edac@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH 5/5] edac: Unify reporting of device info for device, mc
 and pci
Message-ID: <20131029131710.GH10972@pd.tnic>
References: <1381921178-28511-1-git-send-email-rric@kernel.org>
 <1381921178-28511-6-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381921178-28511-6-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 12:59:38PM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@linaro.org>
> 
> Log messages slightly differ between edac subsystems. Unifying it.
> 
> Signed-off-by: Robert Richter <robert.richter@linaro.org>
> Signed-off-by: Robert Richter <rric@kernel.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
