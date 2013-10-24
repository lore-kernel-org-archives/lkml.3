Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3JXHU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:20:57 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:53416 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3JXHUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:20:55 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1382541202-6614-1-git-send-email-treding@nvidia.com>
References: <1382541202-6614-1-git-send-email-treding@nvidia.com>
Date: Thu, 24 Oct 2013 09:20:53 +0200
Message-ID: <CA+icZUUUauzttknp3nK=hE=88gHrz6aC8AsbYR2W_1Uqo8nz8g@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 23
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 5:13 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> Hi all,
>
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
>
>         git://gitorious.org/thierryreding/linux-next.git
>

WebGit URL?

Browsing "https://gitorious.org/thierryreding" gives me a...

"This Git object is too large to be displayed in the browser

Consider cloning the repository locally and look at the object there"

Thierry, you were talking about moving to a <kernel.org> address, what happened?

- Sedat -


> A next-20131023 tag is also provided for convenience.
>
> No new conflicts. I've fixed various build failures, so 32-bit and 64-bit
> allmodconfigs build fine on x86. ARM and x86 default configurations also
> build fine. Most of the patches to fix the build failures have been sent
> to the respective maintainers.
>
> Thierry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
