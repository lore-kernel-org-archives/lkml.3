Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaHKD4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:56:04 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:49017 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaHKD4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1408100856270.32072@skynet.skynet.ie>
References: <20140805130926.4e8c8fe5@canb.auug.org.au>
	<53E0736E.7030901@samsung.com>
	<CAOesGMjjLHOaBJZwFENaWW41KFsNZ3pUqiYk0jtet=8NFvce3g@mail.gmail.com>
	<CAOesGMg=kFM_9ksgoOXgqLFjzoE38tCuPy7pxbG5F_j5KovkVA@mail.gmail.com>
	<alpine.DEB.2.00.1408100856270.32072@skynet.skynet.ie>
Date: Mon, 11 Aug 2014 09:26:00 +0530
Message-ID: <CAK5sBcHceBqYQOQrWw9D0CviVpnXOdAtfgh7pFkT=L53Gfbe6g@mail.gmail.com>
Subject: Re: linux-next: build failures after merge of the drm tree
From: Sachin Kamat <spk.linux@gmail.com>
To: Dave Airlie <airlied@linux.ie>, Inki Dae <daeinki@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, YoungJun Cho <yj44.cho@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Wood <thomas.wood@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 1:28 PM, Dave Airlie <airlied@linux.ie> wrote:
>>
>
> Been on holidays, but ack for anything DT related,
>
> Look I wishI knew how DT worked, and what tree is canonical for changes to
> it, I'm not sure its well defined enough or sub maintaniers know enough,
> so I do just trust the exynos guys with this.
>

Inki,

Can you please get your tree included in linux-next so that these kind of issues
could be detected much earlier (even before they hit Dave's tree)?


-- 
Regards,
Sachin.
