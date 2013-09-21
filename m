Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3IUMdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 08:33:12 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64057 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3IUMdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 08:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbFhORYnAUf+BMXtL1LezL7gPJ6gKQnqwvKZjqqCt3A4Q@mail.gmail.com>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
 <CACRpkdYjkDf7c9VxfDTHtFx_upWWRAK8vpXTkrkrRsMjErq1dQ@mail.gmail.com>
 <20130920193254.GA19130@mithrandir> <CACRpkdbFhORYnAUf+BMXtL1LezL7gPJ6gKQnqwvKZjqqCt3A4Q@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 21 Sep 2013 21:32:47 +0900
Message-ID: <CAAVeFuLyUE_46xKCK23Mr_o2Dp2wZ4vVvcNQrQ6eDK-848RGkg@mail.gmail.com>
Subject: Re: [RFC 0/5] New descriptor-based GPIO interface
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 6:23 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Sep 20, 2013 at 9:32 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>
>> Given that it seems like there won't be a linux-next from September 28
>> until close to the next merge window, it would be good to get this into
>> linux-next before that so that the series can receive broader testing.
>
> Good point. Alexandre: ready when you are.

I really need to test this more extensively, but give me a couple of
days and I will send a real submission of it (not a RFC). Then we can
discuss the small issues that remain.

Thanks,
Alex.
