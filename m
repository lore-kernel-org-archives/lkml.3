Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaHURJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:09:41 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49355 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaHURJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140821170512.GA3796@core.coreip.homeip.net>
References: <1408392810-16011-1-git-send-email-nm@ti.com>
	<1408636935-29515-1-git-send-email-nm@ti.com>
	<1408636935-29515-3-git-send-email-nm@ti.com>
	<20140821170512.GA3796@core.coreip.homeip.net>
Date: Thu, 21 Aug 2014 12:09:38 -0500
X-Google-Sender-Auth: mYFJPUO_-pXrSWTUVRvSdNQbgTs
Message-ID: <CAGo_u6rTnNxRhgOVkUHscB79qWZz3gVWRrM50Cu9ozO8RDsvZg@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] Input: misc: introduce palmas-pwrbutton
From: Nishanth Menon <nm@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: dt list <devicetree@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 12:05 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
>
> You can not use free_irq with devm-managed resources. As I mentioned, since you
> need manual unwinding, I'd rather you not use managed resources in the driver
> at all.
ok. will drop all devm_  ops in the next version.

---
Regards,
Nishanth Menon
