Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaKZSbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:31:33 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:39961 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaKZSbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:31:32 -0500
Date: Wed, 26 Nov 2014 19:30:52 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        grant.likely@linaro.org, robh+dt@kernel.org, plagnioj@jcrosoft.com,
        ijc@debian.org, andrew@lunn.ch, s.hauer@pengutronix.de
Subject: Re: [PATCH v2 2/2] of: support passing console options with
 stdout-path
Message-ID: <20141126183052.GH3443@lunn.ch>
References: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
 <1417023640-23464-3-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417023640-23464-3-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:40:40PM +0000, Leif Lindholm wrote:
> Support specifying console options (like with console=ttyXN,<options>)
> by appending them to the stdout-path property after a separating ':'.
> 
> Example:
>         stdout-path = "uart0:115200";

Hi Leif

This should be documented somewhere under
Documentation/devicetree/bindings/

Not sure where thought. Maybe a top level chosen.txt?

    Andrew
