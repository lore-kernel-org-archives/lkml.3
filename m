Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab3DBRq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:46:59 -0400
Received: from antcom.de ([188.40.178.216]:44395 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759695Ab3DBRq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:46:58 -0400
Message-ID: <515B18C7.7010803@antcom.de>
Date: Tue, 02 Apr 2013 19:43:35 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Martin Knoll <martinknoll@me.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: LPC32xx: changed lpc23xx_restart to lpc32xx_restart
References: <1362601138-16550-1-git-send-email-martinknoll@me.com> <20130402155817.GA25867@quad.lixom.net>
In-Reply-To: <20130402155817.GA25867@quad.lixom.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/13 17:58, Olof Johansson wrote:
> On Wed, Mar 06, 2013 at 09:18:58PM +0100, Martin Knoll wrote:
>> This function has an odd name. This is probably a typo.
> 
> You should cc the platform maintainer on these kind of patches (Roland Stigge).
> But it seems that he's not actually listed in MAINTAINERS.

I indeed missed the above patch - should be a simple syntactic fix in 3
places in arch/arm/. You can go ahead this time and directly take this
fix. Otherwise, please forward to me so I can add it to a lpc32xx tree
and do request pull.

> Roland, can you send a patch adding yourself as LPC32XX maintainer so these
> kind of patches don't get dropped? Thanks!

OK, just did.

Thanks for notifying!

Roland
