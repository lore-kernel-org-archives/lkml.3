Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaFRQju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:39:50 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50445 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaFRQjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:39:49 -0400
Date: Wed, 18 Jun 2014 17:39:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Simon Glass <sjg@chromium.org>, Wolfram Sang <wsa@the-dreams.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mfd: cros_ec: Fix the comment on cros_ec_remove()
Message-ID: <20140618163941.GA25353@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
 <1402954800-28215-2-git-send-email-dianders@chromium.org>
 <20140618075704.GK21030@lee--X1>
 <CAD=FV=Xytn_6jHoWrr7yK41zep8b4H6C=zUxkrRuPu74siU-4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=Xytn_6jHoWrr7yK41zep8b4H6C=zUxkrRuPu74siU-4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> Lee,
> 
> On Wed, Jun 18, 2014 at 12:57 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Mon, 16 Jun 2014, Doug Anderson wrote:
> >
> >> From: Bill Richardson <wfrichar@chromium.org>
> >>
> >> This comment was incorrect, so update it.
> >>
> >> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> >> Signed-off-by: Simon Glass <sjg@chromium.org>
> >
> > How many people did it take to write this patch? ;)
> >
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> There's gotta be a joke here about how many Google engineers it takes
> to fix a comment.  In this case I think the answer is 3: one to fix
> the comment, one to clean it up, and one to send it upstream.  ;)

... and one to hold the ladder. No, wait! ;)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
