Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761142AbaGYPoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:44:15 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41140 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761122AbaGYPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:44:11 -0400
MIME-Version: 1.0
In-Reply-To: <53D276A0.3070800@ti.com>
References: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com>
	<1405499774-19770-3-git-send-email-lokeshvutla@ti.com>
	<53CE9652.4080304@ti.com>
	<53D276A0.3070800@ti.com>
Date: Fri, 25 Jul 2014 10:44:10 -0500
X-Google-Sender-Auth: 9rtbn2aCE3gqP0skZ8-Svj9Z2W4
Message-ID: <CAGo_u6qGYzndVDHxjkoBgfV+adw1FXbhBfRxVPQV2jYq5gt0gA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp
 interface lists
From: Nishanth Menon <nm@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Keerthy <j-keerthy@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:24 AM, Lokesh Vutla <lokeshvutla@ti.com> wrote:
>
> After looking closely into it, I realized that currently its the same logic of what you are
> suggesting.  If there is no error from registering common lists then only go for registering the
> Soc specific lists.
> Do you still want me to go ahead and make this change?


Sure. Ok with me at least.

-- 
---
Regards,
Nishanth Menon
