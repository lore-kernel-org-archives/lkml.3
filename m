Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaAQUCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:02:04 -0500
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:18366 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942AbaAQUCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:02:00 -0500
Message-ID: <52D98C2F.60001@itdev.co.uk>
Date: Fri, 17 Jan 2014 20:01:51 +0000
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yufeng Shen <miletus@google.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, adlr@chromium.org
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver - v6
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>	<20130718194739.GA559@polaris.bitmath.org>	<520CFA0D.4090905@itdev.co.uk>	<20130815160734.GB12196@core.coreip.homeip.net>	<522F2590.1080103@itdev.co.uk>	<CAPDwgkOo7FYLujk16kJM=BqmXRKvZ2S_LOYURW0cXT5t=cmi6w@mail.gmail.com>	<52D66699.8020309@itdev.co.uk> <CAPDwgkOsP4K7r0-Mo-U52X9knRbGgbuD4dGptmj3x-LMTN75BA@mail.gmail.com>
In-Reply-To: <CAPDwgkOsP4K7r0-Mo-U52X9knRbGgbuD4dGptmj3x-LMTN75BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yufeng Shen wrote:
> On Wed, Jan 15, 2014 at 5:44 AM, Nick Dyer <nick.dyer@itdev.co.uk
> <mailto:nick.dyer@itdev.co.uk>> wrote:
>     > We (Chromium authors) are planning on bringing our local tree of atmel
>     > driver to be as close as possible to
>     > upstream and trying to figure out what's the best tree to rebase against.
> 
>     I was considering picking up the patches that Dimitry has already reviewed
>     and rebasing them against the current mainline to try and get things moving
>     again - would that be useful?
> 
> That would certainly be useful. Please let me know the branch/tag name once
> you finish that.

I've rebased Dimitry's atmel-mxt-ts branch against his dtor/next tree. You
can find it at

https://github.com/ndyer/linux/tree/for-next-20140117-dtor-rebase

I needed to update the INIT_COMPLETION api. So far I have verified it
builds, will do some testing on it next week.

I will also need to port my previous patchset on top of this branch.
