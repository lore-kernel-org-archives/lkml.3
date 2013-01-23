Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3AWKHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:07:45 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58499 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3AWKHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:07:42 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbwQAEQxWpXHoEieou5rShcZvsGSddKLaOjwGeG-2o=wg@mail.gmail.com>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
	<1355404930-5691-9-git-send-email-lee.jones@linaro.org>
	<CACRpkdbwQAEQxWpXHoEieou5rShcZvsGSddKLaOjwGeG-2o=wg@mail.gmail.com>
Date: Wed, 23 Jan 2013 11:07:42 +0100
Message-ID: <CACRpkdZnDi8F7Zu646CPEt9SAx5gA=v0CJ-Rq1eJqKS_s2EHvw@mail.gmail.com>
Subject: Re: [PATCH 8/8] ARM: ux500: Remove traces of the ios_handler from
 platform code
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 11:04 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Thu, Dec 13, 2012 at 2:22 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> Now MMCI on/off functionality is using the regulator framework
>> from the MMCI driver, there is no need to keep the ios_handler
>> laying around, duplicating functionality. So we're removing it.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> Applied to my ux500-cleanups branch.

Or no, wait, that is dependent or Russell's tree so will not
be bisectable.

Either submit sequel patches to [1/8] through Russell's
patch tracker (based on his tree I guess) or wait for these
to hit mainline and push them after that.

Acked-by anway, on all of the cleanups following [1/8].

Yours,
Linus Walleij
