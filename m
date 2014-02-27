Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbaB0HHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 02:07:54 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:39773 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaB0HHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 02:07:52 -0500
Date: Thu, 27 Feb 2014 08:07:46 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: select CONFIG_TTY for use of tty in unconditional
 keyboard driver
Message-ID: <20140227070746.GA4343@osiris>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
 <20140226100234.GA23064@thin>
 <20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
 <20140226231916.GB17589@jtriplet-mobl1>
 <20140227104211.b2a4a5a1066fcf8ac2640ce3@canb.auug.org.au>
 <20140227021305.GA23659@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227021305.GA23659@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022707-8372-0000-0000-000008D0C9AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:13:06PM -0800, Josh Triplett wrote:
> The unconditionally built keyboard driver, drivers/s390/char/keyboard.c,
> requires CONFIG_TTY, so select it from CONFIG_S390 to prevent a build
> error.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  arch/s390/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks!

