Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3ISCjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 22:39:55 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59963 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3ISCjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 22:39:54 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458E03F28@US01WEMBX2.internal.synopsys.com>
References: <A2CA0424C0A6F04399FB9E1CD98E030458E03F28@US01WEMBX2.internal.synopsys.com>
Date: Thu, 19 Sep 2013 12:39:53 +1000
Message-ID: <CAPM=9txFE7=e47oY0rqe29DYva2T2MtKHgTjKBtuLfOaNZebZg@mail.gmail.com>
Subject: Re: Regression: bisected: commit 7c510133d93 breaks video
From: Dave Airlie <airlied@gmail.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:02 PM, Paul Zimmerman
<Paul.Zimmerman@synopsys.com> wrote:
> I have an ASUS P6X58D-Premium mobo with a GeForce 9400GT PCIe video card.
> With kernel 3.12-rc1, I get scrambled video on boot. Kernel 3.11 works
> fine.
>
> Bisecting this, I found 7c510133d93dd6f15ca040733ba7b2891ed61fd1 "drm:
> mark context support as a legacy subsystem" is the guilty commit. If I
> revert that commit, the video works fine.
>
> Is there any more info I can provide?

Full dmesg, and what driver you are using.

Dave.
