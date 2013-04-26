Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3DZPTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:19:37 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35870 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3DZPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:19:36 -0400
MIME-Version: 1.0
In-Reply-To: <1577576.O1Cm2pf5KD@wuerfel>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
 <CAFEAcA_xmrHTvR7FxUr3PCKBJY-hZnkeBcqyHksTB4-hqOZS0w@mail.gmail.com>
 <CALrVBkuOmu4u9egdzzfn1tU9B-CFe3w85HZQ9s2gpKvYnaSqvA@mail.gmail.com> <1577576.O1Cm2pf5KD@wuerfel>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 26 Apr 2013 16:19:13 +0100
Message-ID: <CAFEAcA9Vp0H9TMqHg+R+Kv0TzrQoCAt0Gr9c9DE94omp78XXig@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org, Anup Patel <anup.patel@linaro.org>,
        patches@linaro.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 13:33, Arnd Bergmann <arnd@arndb.de> wrote:
> Couldn't kvmtool implement the interface used by smh_printch()
> for early output instead?
>
> Or if that's not a fitting inteface, maybe a psci call for writing
> a character to the console?

I suggested that earlier:
https://lists.cs.columbia.edu/pipermail/kvmarm/2013-April/005433.html

and Alex pointed out that s390-virtio experience with that
approach is that it's awkward for userspace.

-- PMM
