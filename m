Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3AWL1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:27:53 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:40405 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab3AWL1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:27:51 -0500
Date: Wed, 23 Jan 2013 11:27:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: Re: [PATCH 8/8] ARM: ux500: Remove traces of the ios_handler from
 platform code
Message-ID: <20130123112746.GJ15873@gmail.com>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
 <1355404930-5691-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdbwQAEQxWpXHoEieou5rShcZvsGSddKLaOjwGeG-2o=wg@mail.gmail.com>
 <CACRpkdZnDi8F7Zu646CPEt9SAx5gA=v0CJ-Rq1eJqKS_s2EHvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZnDi8F7Zu646CPEt9SAx5gA=v0CJ-Rq1eJqKS_s2EHvw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2013, Linus Walleij wrote:

> On Wed, Jan 23, 2013 at 11:04 AM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
> > On Thu, Dec 13, 2012 at 2:22 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >
> >> Now MMCI on/off functionality is using the regulator framework
> >> from the MMCI driver, there is no need to keep the ios_handler
> >> laying around, duplicating functionality. So we're removing it.
> >>
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > Applied to my ux500-cleanups branch.
> 
> Or no, wait, that is dependent or Russell's tree so will not
> be bisectable.
> 
> Either submit sequel patches to [1/8] through Russell's
> patch tracker (based on his tree I guess) or wait for these
> to hit mainline and push them after that.
> 
> Acked-by anway, on all of the cleanups following [1/8].

I have this queued already, with the MMCI patch in as a dependency.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
