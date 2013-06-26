Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3FZOLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:11:39 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55450 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3FZOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:11:37 -0400
Date: Wed, 26 Jun 2013 16:11:30 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, hpa@linux.intel.com, tglx@linutronix.de
Subject: Re: [PATCH 2/4] x86: efi: break efi_lookup_mapped_addr out to
 generic code
Message-ID: <20130626141130.GC9078@rocoto.smurfnet.nu>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-3-git-send-email-leif.lindholm@linaro.org>
 <20130626133217.GO22026@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626133217.GO22026@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:32:17PM +0100, Matt Fleming wrote:
> On Tue, 25 Jun, at 07:11:01PM, Leif Lindholm wrote:
> > efi_lookup_mapped_addr is a handy helper function for translating
> > a physical address to the corresponding virtual one by scanning
> > through memmap.map.
> > 
> > This patch breaks it out into a new file for use elsewhere.
> > 
> > Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> > ---
> >  arch/x86/platform/efi/efi.c       |   28 ----------------------------
> >  drivers/firmware/efi/Makefile     |    2 +-
> >  drivers/firmware/efi/efi-helper.c |   33 +++++++++++++++++++++++++++++++++
> >  3 files changed, 34 insertions(+), 29 deletions(-)
> >  create mode 100644 drivers/firmware/efi/efi-helper.c
> 
> I'm not sure this function needs its own file. drivers/firmware/efi/efi.c
> is a suitable place for this.

Sure.
Would you be happy for me to start moving the other things mentioned
(config table parsing, common debug printout, global structs) in there too?

/
    Leif
