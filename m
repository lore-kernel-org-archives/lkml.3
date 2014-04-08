Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbaDHQmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:42:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39789 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbaDHQmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:42:33 -0400
Date: Tue, 8 Apr 2014 18:42:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Christopher Covington <cov@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v6 2/5] ARM: Add Krait L2 register accessor functions
Message-ID: <20140408164228.GM30077@pd.tnic>
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
 <1396641450-12854-3-git-send-email-sboyd@codeaurora.org>
 <20140407201838.GC20822@pd.tnic>
 <20140407215649.GH9985@codeaurora.org>
 <20140408064328.GB30077@pd.tnic>
 <534406BD.8000702@codeaurora.org>
 <20140408151056.GH30077@pd.tnic>
 <20140408171929.68f328a9@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140408171929.68f328a9@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:19:29PM +0100, One Thousand Gnomes wrote:
> Including the without warranty is standard practice at a lot of
> companies. It's not even wasting space - it'll compress beautifully as
> there are already lots of similar headers all over the tree.

Right, I was just trying to find out from Stephen/Christopher whether
they're actually really required by legal to slap the boilerplate or
they can get by with a smaller chunk. That's all.

But thanks for this Alan, I was hoping someone would school me on the
legal practice wrt license boilerplates in the kernel, and there you
are. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
