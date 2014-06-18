Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaFRQ0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:26:32 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:48204 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaFRQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:26:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140618075704.GK21030@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-2-git-send-email-dianders@chromium.org>
	<20140618075704.GK21030@lee--X1>
Date: Wed, 18 Jun 2014 09:26:29 -0700
X-Google-Sender-Auth: oG92whrfFDrQpvHCktC2yYAwzs8
Message-ID: <CAD=FV=Xytn_6jHoWrr7yK41zep8b4H6C=zUxkrRuPu74siU-4A@mail.gmail.com>
Subject: Re: [PATCH 01/10] mfd: cros_ec: Fix the comment on cros_ec_remove()
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On Wed, Jun 18, 2014 at 12:57 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, 16 Jun 2014, Doug Anderson wrote:
>
>> From: Bill Richardson <wfrichar@chromium.org>
>>
>> This comment was incorrect, so update it.
>>
>> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
>> Signed-off-by: Simon Glass <sjg@chromium.org>
>
> How many people did it take to write this patch? ;)
>
> Acked-by: Lee Jones <lee.jones@linaro.org>

There's gotta be a joke here about how many Google engineers it takes
to fix a comment.  In this case I think the answer is 3: one to fix
the comment, one to clean it up, and one to send it upstream.  ;)

-Doug
