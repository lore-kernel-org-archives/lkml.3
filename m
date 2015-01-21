Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbbAUCsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:48:24 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:45559 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbAUCsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:48:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAGS+omDxiO_Og4gVwDHb51H4C6w4aeb1ZQpqTJvM-3GgFcMAdw@mail.gmail.com>
References: <1420622830-8608-1-git-send-email-djkurtz@chromium.org>
	<CAGS+omALWyadW50tmU+FbfFGj9RgjQHeYqdEh5ZdWpJnMdnCyg@mail.gmail.com>
	<CAGS+omDxiO_Og4gVwDHb51H4C6w4aeb1ZQpqTJvM-3GgFcMAdw@mail.gmail.com>
Date: Wed, 21 Jan 2015 12:48:20 +1000
Message-ID: <CAPM=9tz_xdkf5LNTfOsARUxQ61vRTSeHt_WHew1tOer8eLG9aA@mail.gmail.com>
Subject: Re: [PATCH] drm/rockchip: fix dma_alloc_attrs() error check
From: Dave Airlie <airlied@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Mark Yao <mark.yao@rock-chips.com>, David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Pawel Osciak <posciak@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2015 at 12:43, Daniel Kurtz <djkurtz@chromium.org> wrote:
> Mark: did you get a chance to fixup the "Reported-by" line?  It's not
> a bit deal if you didn't.
>
> Dave: did you pick up this pull request?  Did Mark request properly?

I was waiting for the fixed reported-by but it isn't that urgent, I'll
get it in the next fixes round.

Dave.
