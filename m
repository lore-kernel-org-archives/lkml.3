Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab3GCKNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 06:13:11 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39439 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3GCKNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 06:13:09 -0400
MIME-Version: 1.0
In-Reply-To: <1372776948-24840-1-git-send-email-coelho@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
Date: Wed, 3 Jul 2013 13:13:08 +0300
Message-ID: <CANOLnOPBHesTiV61zpQ_QS9c7E91K50EnbMnGhvgaViuA_3=Bw@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] wilink: add device tree support
From: Grazvydas Ignotas <notasas@gmail.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, nsekhar@ti.com,
        mturquette@linaro.org, mark.rutland@arm.com,
        Felipe Balbi <balbi@ti.com>, grant.likely@linaro.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        pavel@ucw.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 2, 2013 at 5:55 PM, Luciano Coelho <coelho@ti.com> wrote:
> Hi,
>
> This is a follow-up on a previous patch set that had a smaller
> audience.  This time, I added the lists and people who were involved
> in the review of the bindings documentation, since most of my changes
> in v2 are coming from discussions there.
>
> This patch series adds device tree support to the wlcore_sdio driver,
> which is used by WiLink6, WiLink7 and WiLink8.

Could you perhaps consider doing device tree conversion for wl1251
too? With the knowledge you have from working on this series, it would
be much easier for you to do it than for someone else, and I don't
have much hope someone will do it at all. It's WiLink series chip
after all. Without this pandora and N900 are going to lose wifi
support after the switch to dt-only kernel.

I can offer you my help testing things on pandora and I'm sure someone
here could try it on N900.


--
Gražvydas
