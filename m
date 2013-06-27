Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3F0MTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:19:11 -0400
Received: from mail.abilis.ch ([195.70.19.74]:17993 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab3F0MTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:19:09 -0400
Date: Thu, 27 Jun 2013 14:18:18 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] pinctrl: elaborate a bit on arrangements in doc
Message-ID: <20130627121817.GB25445@ab42.lan>
References: <1372326887-6497-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1372326887-6497-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:54:47AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This elaborates a bit on the pin control and pin muxing
> logic vs GPIO arangements in the hardware.
> 
> Inspired by some drawings in a mail from Christian Ruppert.
> Both arrangements are confirmed to exist in practice.
> 
> Cc: Rob Landley <rob@landley.net>
> Cc: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

To me this sounds very clear.

Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>

> ---
> ChangeLog v1->v2:
> - Cut down to two arrangements that I *know* exist in reality.
> - Reword, rehash, rinse, repeat...

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
