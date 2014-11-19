Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaKSCeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:34:44 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61383 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaKSCem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:34:42 -0500
Date: Wed, 19 Nov 2014 10:34:18 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: kernel@pengutronix.de, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: vf-colibri: add USB regulators
Message-ID: <20141119023416.GB27759@dragon>
References: <1416160828-18168-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416160828-18168-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 07:00:28PM +0100, Stefan Agner wrote:
> Add structure of USB supply logic. The USB hosts power enable
> regulator is needed to control VBUS supply on the Colibri carrier
> board.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Applied, thanks.
