Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaLDJoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:44:55 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:53116 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaLDJox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:44:53 -0500
MIME-Version: 1.0
In-Reply-To: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Thu, 4 Dec 2014 10:44:52 +0100
Message-ID: <CACRpkdbYPmMksbqciiXv4hHBqx9=b8toA5MgCwGSLteUh+NkZA@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Pinctrl support for Zynq
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 2:26 AM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> here is v2 of this series. On the functional side, adding the support
> for USB mux groups is probably the biggest change. Most other changes
> are mostly cosmetic (typos, function names, documentation, ...).
> More detailed changelogs are included with the respective patches.

Unfortunately we are late in the merge cycle.

But I am *very* fond of this series, and I appreciate your patches
as *lot* Sören.

So my plan is to merge your v3 patch set after the merge window
or whenever you have it ready, with the Zynq driver on top and
the dependent AMlogic driver too.

Then we spend the next kernel cycle hashing this out and
putting some polished generic code in place so we get some
order.

This will likely set the pattern for how we expect ACPI pin controllers
to behave too, so it is work of great importance.

I hope I can count on you to hang in there and keep driving
those patches!

I'll try to provide a deeper look at the indivudual patches now.

Yours,
Linus Walleij
