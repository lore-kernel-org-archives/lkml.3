Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaIAXjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 19:39:09 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42299 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaIAXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 19:39:07 -0400
Date: Tue, 2 Sep 2014 08:39:01 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: renesas_usbhs: fix driver dependencies
Message-ID: <20140901233900.GB15867@verge.net.au>
References: <1601192.oClrOJlUe8@amdc1032>
 <CAMuHMdVp16nXS1GefyV0OD7Dwewct0UPTEEYLj+GKCrnBxjhLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVp16nXS1GefyV0OD7Dwewct0UPTEEYLj+GKCrnBxjhLw@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 06:40:50PM +0200, Geert Uytterhoeven wrote:
> On Mon, Sep 1, 2014 at 4:24 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > Renesas USBHS controller support should be available only on
> > Renesas ARM SoCs and SuperH architecture.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Magnus Damm <magnus.damm@gmail.com>
> > ---
> > v2:
> > - s/ARCH_SH/SUPERH/ (thanks to Sergei Shtylyov)
> 
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

