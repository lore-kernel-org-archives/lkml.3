Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaLUTfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:35:06 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33079 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaLUTfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:35:02 -0500
Date: Sun, 21 Dec 2014 11:34:58 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, hl@rock-chips.com,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] CHROMIUM: clk: rockchip: add clock IDs for the PVTM
 clocks
Message-ID: <20141221193458.GA8160@dtor-ws>
References: <1418948026-3463-1-git-send-email-dtor@chromium.org>
 <2752828.P8uvZNT2Jv@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2752828.P8uvZNT2Jv@phil>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Sun, Dec 21, 2014 at 03:14:53PM +0100, Heiko Stübner wrote:
> Hi Dmitry,
> 
> This looks ok and also like it's meant to go upstream, because it still has 
> the CHROMIUM-prefix?
> 
> No need to resend, I remove them myself, just want to make sure here :-)

Yes, my bad, I failed to sanitize the commit messages properly. Both of
these are meant for upstream.

Thanks!

-- 
Dmitry
