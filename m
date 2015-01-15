Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbbAOKN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:13:58 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35298 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbbAOKNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:13:55 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.140.40]
In-Reply-To: <1421269101-51105-1-git-send-email-s-anna@ti.com>
References: <1421269101-51105-1-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 15 Jan 2015 12:13:34 +0200
Message-ID: <CAK=Wgba1S58OMs=FTfv=UraU_3EZn_eOLmADtCjrvJkDSGw8WA@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] hwspinlock core & omap dt support
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Wed, Jan 14, 2015 at 10:58 PM, Suman Anna <s-anna@ti.com> wrote:
> This is an updated version of the hwspinlock dt support series,
> rebased onto v3.19-rc3 and mainly addresses the continued discussion
> on the need to maintain a list of registered spinlock banks [1].
> I have removed this patch as per your wish, and as a result the
> burden of the spinlock validation and deferred probing is pushed
> onto the hwspinlock clients. Sorry for the delay in refreshing this
> series, hopefully this can be the last revision.
>
> Following are the main changes in v7 w.r.t v6:
> - Dropped the patch "hwspinlock/core: maintain a list of registered
>   hwspinlock banks"
> - Updated generic hwspinlock bindings to make hwlock-base-id property
>   mandatory.
> - Updated the OMAP hwspinlock binding and DT support patches to correct
>   for the mandatory hwlock-base-id property.
> - Updated the common OF helpers patch to move the of_hwspin_lock_get_base_id()
>   and of_hwspin_lock_get_num_locks() functions into the internal header,
>   these are no longer exported, but available for platform implementations.
>   of_hwspin_lock_get_id() is also simplified now.

This looks good, thanks.

Please try to get an ACK from a DT maintainer on the first two dt
patches, and then I can take the patches to Linus.

Thanks,
Ohad.
