Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaIOMVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:21:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41729 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaIOMVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:21:41 -0400
Date: Mon, 15 Sep 2014 14:21:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "open list:EDAC-CORE" <linux-edac@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andre Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] edac: Fix build error caused by wrong member access
Message-ID: <20140915122139.GE3340@nazgul.tnic>
References: <1408482646-22541-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1408482646-22541-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 05:10:46PM -0400, Pranith Kumar wrote:
> Fix the following error 
> 
> drivers/edac/ppc4xx_edac.c:977:45: error: request for member 'dimm' in something
> not a structure or union
> 
> by changing member access to pointer dereference
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Andre Morton <akpm@linux-foundation.org>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.
--
