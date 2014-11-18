Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaKRPHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:07:24 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51379 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaKRPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <546B5D5A.8020304@ti.com>
References: <20141117190905.4e96294a@canb.auug.org.au>
	<546B5D5A.8020304@ti.com>
Date: Tue, 18 Nov 2014 16:07:19 +0100
Message-ID: <CANq1E4SMLHmezfXSENSQ8xUaXptwA8YKQ9Nne=sDCB0gPkPLmA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
From: David Herrmann <dh.herrmann@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Luc Verhaegen <libv@skynet.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Nov 18, 2014 at 3:53 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> Hi,
>
> Thanks Stephen!
>
> Hans, have you had a look at this? kbuild test bot also reported this.

The fix from Stephen should not go to main-line. It breaks simplefb on
x86 without OF. Imo, linux/clk.h should provide a fallback if OF is
not defined (like it already does for of_clk_get() and friends).

Hans, any comments?

Thanks
David
