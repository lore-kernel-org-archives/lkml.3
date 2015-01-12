Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbbALUsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:48:46 -0500
Received: from gloria.sntech.de ([95.129.55.99]:34754 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbbALUsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:48:45 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, hl@rock-chips.com,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] CHROMIUM: clk: rockchip: add clock IDs for the PVTM clocks
Date: Mon, 12 Jan 2015 21:48:32 +0100
Message-ID: <1433709.FpyhqD6lRX@phil>
User-Agent: KMail/4.14.2 (Linux/3.16.0-4-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1418948026-3463-1-git-send-email-dtor@chromium.org>
References: <1418948026-3463-1-git-send-email-dtor@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 18. Dezember 2014, 16:13:45 schrieb Dmitry Torokhov:
> From: Huang Lin <hl@rock-chips.com>
> 
> Process-Voltage-Temperature Monitor has two clocks, PVTM_CORE and
> PVTM_GPU.
> 
> Signed-off-by: Huang Lin <hl@rock-chips.com>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

applied both patches to my tree

The clock-id addition is living in a separate branch, so if you have dts 
updates using this I can share the clock-id branch easily.


Heiko
