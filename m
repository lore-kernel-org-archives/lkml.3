Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbaDPVeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:34:50 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:49920 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbaDPVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140416205136.GZ12304@sirena.org.uk>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
	<1397672724-9063-1-git-send-email-dianders@chromium.org>
	<1397672724-9063-6-git-send-email-dianders@chromium.org>
	<20140416205136.GZ12304@sirena.org.uk>
Date: Wed, 16 Apr 2014 14:34:47 -0700
X-Google-Sender-Auth: 1DZMOCVJWDDJHFU6MblkWKo0GeQ
Message-ID: <CAD=FV=Wf=hdggX-Z1gtiVJdwr7jwjY1owCVZDq_BrWOyj-3m3A@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] regulator: tps65090: Make FETs more reliable by
 adding retries
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, Apr 16, 2014 at 1:51 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Apr 16, 2014 at 11:25:24AM -0700, Doug Anderson wrote:
>> An issue was discovered with tps65090 where sometimes the FETs
>> wouldn't actually turn on when requested (they would report
>> overcurrent).  The most problematic FET was the one used for the LCD
>
> Please don't send new patches as replies in the middle of threads, it
> makes it confusing trying to work out which versions of things should be
> applied.

I'm a little confused about what I did wrong.  Can you give more details?

* V1 had 3 patches plus a cover letter.

* I was asked to split two patches, so V2 has 5 patches plus a cover letter.

* My v2 series was all "in reply to" the v1 cover letter, which I
thought was best practice.

* All of my v2 patches were marked with v2 and included changes
between v1 and v2.

* Everyone was CCed on the cover letter.  Only appropriate people were
CCed on the individual patches (as per get_maintainer, automated by
patman).

* All patches were resent at v2.


If I had to answer your question, I'd say that you should now
completely ignore v1 and look at v2.

-Doug
