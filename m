Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbaGXO2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:28:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42426 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbaGXO2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:28:07 -0400
Date: Thu, 24 Jul 2014 16:28:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 5/8] x86, microcode, intel: don't use fields from unknown
 format header
Message-ID: <20140724142802.GN19239@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-6-git-send-email-hmh@hmh.eng.br>
 <20140724113726.GL19239@pd.tnic>
 <20140724133059.GA32421@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140724133059.GA32421@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 10:30:59AM -0300, Henrique de Moraes Holschuh wrote:
> We care about ->hdrver to get data from the header. We only care about
> ->ldrver for the exact procedure to install it in the processor.

Does it matter?

microcode_sanity_check() errors out if any of the two are not 1 and we
end up not applying the microcode if so.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
