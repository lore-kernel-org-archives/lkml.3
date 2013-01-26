Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3AZVVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:21:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38862 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab3AZVVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:21:45 -0500
Date: Sat, 26 Jan 2013 22:24:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: Fix kcalloc argument order
Message-ID: <20130126212432.GC16044@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>,
	Doug Thompson <dougthompson@xmission.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <1359228240.2079.29.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359228240.2079.29.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 11:24:00AM -0800, Joe Perches wrote:
> First number, then size.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
