Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaGCVF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:05:56 -0400
Received: from p3plsmtpa12-05.prod.phx3.secureserver.net ([68.178.252.234]:32909
	"EHLO p3plsmtpa12-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbaGCVFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:05:55 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 17:05:55 EDT
Date: Thu, 3 Jul 2014 13:57:40 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-nfc] [PATCH] NFC: trf7970a: Move trf7970a_init inside
 #ifdef CONFIG_PM_RUNTIME
Message-ID: <20140703205740.GA19951@animalcreek.com>
References: <1402923973-24316-1-git-send-email-geert@linux-m68k.org>
 <20140616155855.GA2539@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140616155855.GA2539@animalcreek.com>
Organization: Animal Creek Technologies, Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 08:58:55AM -0700, Mark A. Greer wrote:
> On Mon, Jun 16, 2014 at 03:06:13PM +0200, Geert Uytterhoeven wrote:
> > If CONFIG_PM_RUNTIME=n:
> > 
> > drivers/nfc/trf7970a.c:755: warning: ‘trf7970a_init’ defined but not used
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Acked-by: Mark A. Greer <mgreer@animalcreek.com>

Actually, I'd like to change my mind on this.  I've modified the code
locally and I will have to move trf7970a_init() back to where it originally
was again, if this patch is taken.  If you can tolerate the warning for
another week or so, I'll have a new set of patches that will fix it.

Not a big deal if you still want to take it.

Mark
--
