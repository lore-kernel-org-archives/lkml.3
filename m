Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3FGAkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:40:47 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46084 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3FGAkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:40:45 -0400
Date: Thu, 6 Jun 2013 17:36:30 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] power: replace strict_strtoul() with kstrtoul()
Message-ID: <20130607003629.GG7052@lizard.sbx05280.losalca.wayport.net>
References: <000901ce6039$7071c670$51555350$@samsung.com>
 <CAHp75Vdrhi=sX_MxeT6oqW6s8bbxqWr+rw4PsCYSepw+yffXWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHp75Vdrhi=sX_MxeT6oqW6s8bbxqWr+rw4PsCYSepw+yffXWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 01:49:49PM +0300, Andy Shevchenko wrote:
> On Mon, Jun 3, 2013 at 12:05 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> > The usage of strict_strtoul() is not preferred, because
> > strict_strtoul() is obsolete. Thus, kstrtoul() should be
> > used.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Looks better.
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied, thanks a lot!

Anton
