Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3DYJRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:17:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37541 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3DYJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:17:50 -0400
Date: Thu, 25 Apr 2013 10:17:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 07/32] ARM: ux500: Supply address location names for the
 DMA40 DMA controller
Message-ID: <20130425091744.GF4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-8-git-send-email-lee.jones@linaro.org>
 <CACRpkdbCMjC22WbgE_-Co-hvT704n696Ox8t_6_d2aoxmZyybA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbCMjC22WbgE_-Co-hvT704n696Ox8t_6_d2aoxmZyybA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The DMA40 controller uses two sets of base addresses. In order to have
> > them automatically setup as resources by the Open Format framework we
> > have to set names for them. The names have to be the same as the ones
> > used to fetch them back out of the resource structure.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This is OK with Arnds suggested changed, but I want the patch
> split off from this series and put into a device-tree-specific patch
> series so I can apply this to a branch where I try to keep
> all patches to the device tree files. (ux500-devicetree).

Do you want to take this one separately?

Feel free and I'll remove it from this set.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
