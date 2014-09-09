Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbaIIMPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:15:52 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:43529 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaIIMPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:15:50 -0400
MIME-Version: 1.0
In-Reply-To: <540EE4B0.70207@ti.com>
References: <1410203998-8700-1-git-send-email-mugunthanvnm@ti.com>
	<20140908193440.GC12150@kahuna>
	<540EE4B0.70207@ti.com>
Date: Tue, 9 Sep 2014 07:15:49 -0500
X-Google-Sender-Auth: 4RWa7I7dHVPHbax9Yd8GQbabMDU
Message-ID: <CAGo_u6riiMVTW2y1qZWdJ2QUVdxX7uZyaTO3tRTGivX8Pjni1w@mail.gmail.com>
Subject: Re: [resend PATCH 0/3] Add DRA7xx CPSW Ethernet support in Device Tree
From: Nishanth Menon <nm@ti.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        dt list <devicetree@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 6:29 AM, Mugunthan V N <mugunthanvnm@ti.com> wrote:
>
>> Sorry this is now blocked inside TI. could you explain the testing done
>> for sleep state? did you attempt sleep mode before testing this?
>>
>
> I have not tested sleep mode, just tested boot and ping test.

I must NAK then for the reason that this is a patch that is just build
tested and is not tested for the feature it claims to introduce.


-- 
---
Regards,
Nishanth Menon
