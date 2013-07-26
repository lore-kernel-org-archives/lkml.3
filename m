Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab3GZKjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:39:17 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37073 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3GZKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:39:15 -0400
Date: Fri, 26 Jul 2013 12:39:12 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/10] ARM: sunxi: dt: Add PIO controller to A31 DTSI
Message-ID: <20130726123912.3dd65bb7@skate>
In-Reply-To: <1374618312-19001-9-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
	<1374618312-19001-9-git-send-email-maxime.ripard@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime Ripard,

On Wed, 24 Jul 2013 00:25:10 +0200, Maxime Ripard wrote:
> The A31 has a different set of pins than the one found on the A10 and
> A13, so we will need a different compatible string, even though the IP
> is the same.

Why "we will" ? Isn't this patch presently using a different compatible
string?

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
