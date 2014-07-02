Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaGBEQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:16:08 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:54283 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbaGBEQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:16:06 -0400
Message-ID: <53B38780.5020808@vmware.com>
Date: Wed, 02 Jul 2014 06:16:00 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christopher Friedt <chrisfriedt@gmail.com>
CC: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-graphics-maintainer@vmware.com
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com> <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com> <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com> <53B14E9E.3040505@vmware.com> <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com> <53B15A94.3010402@vmware.com> <CAF4BF-TiHkaaOejH6p1QnnepfOxmvirds3vQD2YdXih_6kkUpQ@mail.gmail.com> <CAF4BF-T8a_Y=uW7r_g0WKpABHFH=GhX0hNAQMsG9o=DX4JF6qg@mail.gmail.com> <53B16492.6040006@vmware.com> <CAF4BF-R_b0_7tzqsMu0UENYtdQ7P=2x6ELLhMB38_4u9Fc58RQ@mail.gmail.com>
In-Reply-To: <CAF4BF-R_b0_7tzqsMu0UENYtdQ7P=2x6ELLhMB38_4u9Fc58RQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 05:01 AM, Christopher Friedt wrote:
> I have been unable to reproduce this issue in a plethora of test
> cases, although granted, I do not have access to a Win7 machine. For
> that, I have asked an Ubuntu tester to run through some tests for me.
>
> https://urldefense.proofpoint.com/v1/url?u=https://bugs.launchpad.net/ubuntu/%2Bsource/xserver-xorg-video-vmware/%2Bbug/1328898/comments/8&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=dUdnjNSVc8rpaH6Jc63zkOFO0Bari6xxf72ZYyMo%2Bk4%3D%0A&s=0c96076761f2340d2de78dcf53d1f2a616d7b932cae49bccbf8268f7520815c5
>
> Will post updates as I receive them
Indeed, same here, although I only tested on Linux host.

I've got confirmation from the device developers that the register in
question is indeed a read only register, so I'll post a patch.
However, it would be good if you could confirm that the fbdev problem
your patch fixed works also without the write to
SVGA_REG_BUTES_PER_LINE

Thanks,
Thomas
