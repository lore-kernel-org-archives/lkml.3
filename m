Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaGDFBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 01:01:52 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35607 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaGDFBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 01:01:51 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <53B592CE.2010001@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
 <1398904476-26200-4-git-send-email-s-anna@ti.com> <CAK=WgbakGbTaYz+4K24aT3vyRkDYwPKCm6XrcJvH667NMMfTTA@mail.gmail.com>
 <53B47621.6090307@ti.com> <CAK=WgbYtJ7TGqvjG3VAPPD5tVXx9-jEJU3iKEStUMxOvD1v=LQ@mail.gmail.com>
 <53B592CE.2010001@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 4 Jul 2014 08:01:29 +0300
Message-ID: <CAK=WgbaahqdmWRDMKtRhco4y5B-WBFYDHYs2cLM7NL=QhnhK2Q@mail.gmail.com>
Subject: Re: [PATCHv5 03/15] hwspinlock/core: maintain a list of registered
 hwspinlock banks
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Thu, Jul 3, 2014 at 8:28 PM, Suman Anna <s-anna@ti.com> wrote:
> OK, but we would still require this function to lookup the registered
> device from the controller-phandle to retrieve the base_id.

Can we retrieve the base_id from the parent DT node itself?

Thanks,
Ohad.
