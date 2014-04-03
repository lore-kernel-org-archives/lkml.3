Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaDCOUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:20:41 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40730 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbaDCOUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:20:39 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: rockchip: fix offset of mux registers for rk3188
Date: Thu, 03 Apr 2014 16:20:45 +0200
Message-ID: <1810753.STDdFhitt6@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CACRpkda9Lh19sfkxs3=dNWbg4FgkAtY2tJdMQik=TGs8wUkYfA@mail.gmail.com>
References: <1395700561-3793-1-git-send-email-b.galvani@gmail.com> <CACRpkda9Lh19sfkxs3=dNWbg4FgkAtY2tJdMQik=TGs8wUkYfA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. April 2014, 16:10:46 schrieb Linus Walleij:
> On Mon, Mar 24, 2014 at 11:36 PM, Beniamino Galvani <b.galvani@gmail.com> 
wrote:
> > The correct value of .mux_offset for rk3188 seems to be 0x60
> > instead of 0x68.
> > 
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> 
> Patch applied to fixes with Heiko's Review tag and also
> copied some info from the conversation into the commit message.

small protest note

"Heikki adds:" - sounds somehow finish or swedish, but who is this guy? ;-)


But it doesn't really matter, so no need to roll it back

Heiko
