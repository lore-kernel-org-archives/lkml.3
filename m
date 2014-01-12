Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaALSGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:06:49 -0500
Received: from void.printf.net ([89.145.121.20]:58465 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaALSGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:06:46 -0500
From: Chris Ball <chris@printf.net>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v3 1/2] mmc: arasan: Add driver for Arasan SDHCI
References: <1386007357-11956-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Sun, 12 Jan 2014 18:06:32 +0000
In-Reply-To: <1386007357-11956-1-git-send-email-soren.brinkmann@xilinx.com>
	(Soren Brinkmann's message of "Mon, 2 Dec 2013 10:02:36 -0800")
Message-ID: <861u0ddqhj.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On Mon, Dec 02 2013, Soren Brinkmann wrote:
> Add a driver for Arasan's SDHCI controller core.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com> [binding]

Thanks, pushed patch 1/2 to mmc-next for 3.14.

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
