Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab3DZGvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:51:23 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45865 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3DZGvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <1366202211-6743-2-git-send-email-andreas@gaisler.com>
References: <1366202211-6743-1-git-send-email-andreas@gaisler.com>
	<1366202211-6743-2-git-send-email-andreas@gaisler.com>
Date: Fri, 26 Apr 2013 08:51:22 +0200
Message-ID: <CACRpkdZV3_59XUyOCYHxDH+HZoBxgNCP=-NZRvH+bXaFS1C5-g@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] gpio: grgpio: Add device driver for GRGPIO cores
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 2:36 PM, Andreas Larsson <andreas@gaisler.com> wrote:

> This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP
> core library from Aeroflex Gaisler.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Patch applied.

It's late in the merge cycle but this is a new driver and you
have done a terrific job, so merging.

Yours,
Linus Walleij
