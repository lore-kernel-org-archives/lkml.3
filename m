Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaFZJY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:24:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:59246 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaFZJY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <1403696634-12779-1-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-5-git-send-email-t.figa@samsung.com>
	<1403696634-12779-1-git-send-email-t.figa@samsung.com>
Date: Thu, 26 Jun 2014 10:24:23 +0100
Message-ID: <CAD8Lp46X_urw=ayVZNL8Af9pMUD4st7tAtuMvkrg+A6YsxpiMw@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] ARM: SAMSUNG: Restore Samsung PM Debug functionality
From: Daniel Drake <drake@endlessm.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 12:43 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Due to recently merged patches and previous merge conflicts, the Samsung
> PM Debug functionality no longer can be enabled. This patch fixes
> incorrect dependency of SAMSUNG_PM_DEBUG on an integer symbol and adds
> missing header inclusion.

I replaced the original patch with this updated version and can
confirm that the option now appears in the menu again, and compile
succeeds when set to yes.

Thanks
Daniel
