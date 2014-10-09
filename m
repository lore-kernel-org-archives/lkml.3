Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaJIUjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:39:37 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39205 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:39:34 -0400
MIME-Version: 1.0
In-Reply-To: <1411659697-27258-1-git-send-email-octavian.purdila@intel.com>
References: <1411659697-27258-1-git-send-email-octavian.purdila@intel.com>
Date: Thu, 9 Oct 2014 23:39:33 +0300
Message-ID: <CAE1zotLYqdV-m6XYo9QKndbyrEUAxgws5uqdNEs+CT_RcWeGHg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mfd: viperboard: fix cache line sharing and cleanups
From: Octavian Purdila <octavian.purdila@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:41 PM, Octavian Purdila
<octavian.purdila@intel.com> wrote:
> Changes since v3:
>
>  * undo a whitespace change
>
>  * one more error path cleanup
>
>  * add commit body to the last patch
>
> Changes since v2:
>
>  * switch to using devm_ allocation
>
>  * remove unused platform_device
>
> Changes since v1:
>
>  * split cache sharing fix and cleanups into separate patches
>
>
> Octavian Purdila (3):
>   mfd: viperboard: allocate I/O buffer separately
>   mfd: viperboard: switch to devm_ allocation
>   mfd: viperboard: remove unused platform_device
>
>  drivers/mfd/viperboard.c       | 18 ++++++++----------
>  include/linux/mfd/viperboard.h |  3 +--
>  2 files changed, 9 insertions(+), 12 deletions(-)
>

Hi Lee,

Does these look ok now?

Thanks,
Tavi
