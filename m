Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3IAMxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 08:53:52 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:56538 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3IAMxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 08:53:50 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au1DAEQ4I1JV5qu1PGdsb2JhbABagweDZgGFALkLgR4XAwEBAQE4NYIkAQEFOhwjEAgDGAklDwUNGAoaE4dwAxOvZw2JaBaMeYJwB4MdgQADlgyBaIZAhXiIUTo
X-IronPort-AV: E=Sophos;i="4.89,1001,1367964000"; 
   d="scan'208";a="311007215"
Date: Sun, 1 Sep 2013 14:59:53 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Linus G Thiel <linus@hanssonlarsson.se>
Cc: Ian Munsie <darkstarsword@gmail.com>, Brad Ford <plymouthffl@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: apple: Add another device ID for the mid-2013
 Macbook Air
Message-ID: <20130901125953.GA10475@polaris.bitmath.org>
References: <1377353873-17000-1-git-send-email-darkstarsword@gmail.com>
 <1377353873-17000-2-git-send-email-darkstarsword@gmail.com>
 <20130825071122.GA12567@polaris.bitmath.org>
 <CAH4=b6LSE0XJPwLAz+oeb98mbdYyocr_AdWvU+T98-oHST2=Cg@mail.gmail.com>
 <CAG4XgJTX13d9-2X7g7Dpi+O6nFhsufAijAnVpAczwrkiLrrZng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4XgJTX13d9-2X7g7Dpi+O6nFhsufAijAnVpAczwrkiLrrZng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 02:51:32PM +0200, Linus G Thiel wrote:
> I'm on an ISO layout, this is what makes sense to me and it also works fine
> on my laptop (6,2 with Swedish layout).
> 
> 
> On Mon, Aug 26, 2013 at 3:50 AM, Ian Munsie <darkstarsword@gmail.com> wrote:
> 
> > > Brad, Linus, does the above patch work for you as well as for Ian?
> >
> > That would work fine for me, but I guess we need confirmation from
> > someone with the ISO or JIS layouts.
> >
> > Cheers,
> > -Ian

Thanks for the tests, we will assume it works for Brad as well. I will send a new patch.

Henrik
