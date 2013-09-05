Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab3IEXBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 19:01:30 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61576 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab3IEXB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 19:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFybVR6MqWpQfTu3jK8mgSg8Z53gz0Ah77ZK1+40Fx=FsQ@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
	<20130905153243.43d0346e@jbarnes-desktop>
	<CA+55aFybVR6MqWpQfTu3jK8mgSg8Z53gz0Ah77ZK1+40Fx=FsQ@mail.gmail.com>
Date: Thu, 5 Sep 2013 16:01:26 -0700
X-Google-Sender-Auth: DC8jWYSokUDAtMpP87iz6Fwfrjc
Message-ID: <CA+55aFwSYzK6KDojF6j3CvjkfXABUTibRmws70UMrhOiA5LN-w@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Beauchesne, Gwenole" <gwenole.beauchesne@intel.com>,
        Sean V Kelley <sean.v.kelley@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 3:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Looking more closely at the log-file, I notice that the

oops, pressed the send-button a bit too early..

Anyway, looking more closely at the log-file, I notice that while it
has zero errors, it does seem to end just where a successful log-file
has the EDID information (for the second time).

But that may be normal and not indicate anything wrong with EDID at
all - looking at the timestamps that second EDID probe may happen when
you log in, and I obviously never logged in due to being all blind.

        Linus
