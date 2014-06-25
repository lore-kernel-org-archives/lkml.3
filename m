Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaFYKJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:09:18 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49332 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaFYKJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <1403618235-19353-5-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
	<1403618235-19353-5-git-send-email-t.figa@samsung.com>
Date: Wed, 25 Jun 2014 11:09:11 +0100
Message-ID: <CAD8Lp46GpaGzq+2bkyujRtSVYJt7PWWT47NvjifoxzJk7aKs6A@mail.gmail.com>
Subject: Re: [PATCH 4/6] ARM: SAMSUNG: Restore Samsung PM Debug functionality
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

Hi Tomasz,

On Tue, Jun 24, 2014 at 2:57 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Due to recently merged patches and previous merge conflicts, the Samsung
> PM Debug functionality no longer can be enabled. This patch fixes
> incorrect dependency of SAMSUNG_PM_DEBUG on an integer symbol and adds
> missing header inclusion.

Testing against 3.16-rc2, this doesn't quite work for me.
SAMSUNG_PM_DEBUG still doesn't appear in menuconfig.

HAVE_SAMSUNG_PM_DEBUG is 'n'. Looks like the select from
DEBUG_S3C_UART is not working, but I'm not sure why.

Daniel
