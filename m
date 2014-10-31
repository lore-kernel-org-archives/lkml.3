Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaJaIUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:20:02 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:40236 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbaJaIT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <62aa98fc84d14f919e35dd068d24e5a7@BN1BFFO11FD060.protection.gbl>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
	<1413479495-14206-4-git-send-email-soren.brinkmann@xilinx.com>
	<CACRpkdZtqNUroNfd_0Kftq+-056YFzjvR+ROrZZ0htZX2v2qzg@mail.gmail.com>
	<62aa98fc84d14f919e35dd068d24e5a7@BN1BFFO11FD060.protection.gbl>
Date: Fri, 31 Oct 2014 09:19:59 +0100
Message-ID: <CACRpkdYuFyRSZKp8u2dC4kCxojSrjYJ51_U+bkWnJuKeq7Hrvg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/8] pinctrl: pinconf-generic: Add parameter 'IO standard'
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 5:07 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> So, this might also map to a certain drive-strength, but is not really
> mapping well to Zynq pin configuration options.
> Hence, I thought introducing this new property which allows a more
> flexible interpretation of the argument would be a better way and might
> also help other pinctrl cases (though this is speculative).

Maybe a new property is needed, but it doesn't seem generic enough.

It may be that you need to have a combination of generic and custom
config options (which is fine).

It may need some tweaking of the generic DT config parser to allow
custom attributes but that's needed one of these days anyway.

Yours,
Linus Walleij
