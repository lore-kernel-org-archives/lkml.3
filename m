Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3LUOWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 09:22:25 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41816 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3LUOWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 09:22:24 -0500
Date: Sat, 21 Dec 2013 14:22:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: shawn.guo@linaro.org, b20788@freescale.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20131221142201.GE30815@sirena.org.uk>
References: <1387550902-6086-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387550902-6086-1-git-send-email-festevam@gmail.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 217.42.81.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] regulator: anatop-regulator: Also provide a delay when
 voltage decreases
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 12:48:22PM -0200, Fabio Estevam wrote:

> I could not find in the reference manual anywhere that says that the delay
> should de done only when the voltage increases.

The reason this is normally not done is that generally consumers don't
care too much if the supply is too high but will fail if they get an
undervoltage supply so there's not such a great need to wait.

It can also be hard to tell how quickly the voltage will fall.
