Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3FGAbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:31:05 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35970 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3FGAbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:31:03 -0400
Date: Thu, 6 Jun 2013 17:26:46 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power_supply: pm2301_charger: Fix NULL pointer
 dereference
Message-ID: <20130607002645.GC7052@lizard.sbx05280.losalca.wayport.net>
References: <1368696660.8439.1.camel@phoenix>
 <CACRpkdYxgOFZU6GudXbkEgnrqZZ-Mv6zwR3K_U3ZXjNhj8PbfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACRpkdYxgOFZU6GudXbkEgnrqZZ-Mv6zwR3K_U3ZXjNhj8PbfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 03:45:55PM +0200, Linus Walleij wrote:
> On Thu, May 16, 2013 at 11:31 AM, Axel Lin <axel.lin@ingics.com> wrote:
> 
> > Add checking pl_data in probe, this prevent possible NULL pointer dereference.
> > Also fix NULL pointer deference in dev_err when allocate memory for pm2 fails.
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks!

Anton
