Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab3GaVGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:06:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49441 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336Ab3GaVGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:06:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: i915 backlight
Date: Wed, 31 Jul 2013 23:16:52 +0200
Message-ID: <1419236.138PcnXVBh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130731163623.GD4724@pd.tnic>
References: <20130731162252.GC4724@pd.tnic> <20130731163623.GD4724@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 31, 2013 06:36:23 PM Borislav Petkov wrote:
> On Wed, Jul 31, 2013 at 06:22:52PM +0200, Borislav Petkov wrote:
> > Dudes,
> > 
> > has anyone already reported this (happens on Linus of today +
> > tip/master):
> 
> Oh, one more thing: I can't control the backlight anymore on this x230
> with the Fn-Fx keys and this is most probably related to that recent
> backlight revert story. If there is a new approach I can test, please
> let me know.
> 
> Btw, it worked before on this machine with "acpi_backlight=vendor" on
> the cmdline.

Does reverting efaa14c help?

Rafael

