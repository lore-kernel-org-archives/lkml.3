Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3I0MG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:06:59 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39012 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3I0MG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:06:56 -0400
MIME-Version: 1.0
In-Reply-To: <1380179668-32288-1-git-send-email-acourbot@nvidia.com>
References: <1380179668-32288-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 27 Sep 2013 14:06:54 +0200
Message-ID: <CACRpkdbhywp7_wAhOSzdMe==YoCo0mAcy1mJrdW3bURKWLxQeQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] New descriptor-based GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 9:14 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Here is a proper patch series for the descriptor-based GPIO interface to be
> merged into -next. It is rebased on your for-next branch and only slightly
> changed with respect to the RFC I posted earlier, only more thoroughly tested.
> The documentation part is missing because I need some more time to rework it
> (I'm on holidays this week but wanted to get the code into -next before 28th),
> and anyway at this point I just want to make sure that the extra refactoring
> does not break any existing code.
>
> My hope is to get this into -next before the 28th so this patchset can be
> effectively tested, even if the new interfaces are not used yet. Since the old
> integer-based interface now relies on top of gpiod_, this should provide good
> coverage for both.

I've applied it now, but no idea whether it will hit the last -next tree in
time, hopefully at the very last second ...

Yours,
Linus Walleij
