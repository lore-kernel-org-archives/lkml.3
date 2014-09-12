Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaILQhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:37:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaILQh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:37:29 -0400
Date: Fri, 12 Sep 2014 09:37:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, oleg.drokin@intel.com,
        andreas.dilger@intel.com, devel <devel@driverdev.osuosl.org>
Subject: Re: randconfig build error with next-20140912, in
 drivers/staging/lustre/lustre/obdclass
Message-ID: <20140912163728.GA27559@kroah.com>
References: <CA+r1ZhiLP+JTnV2w=PgWTHgW6KbcPuactc6Mr9OkSXdERFGMtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+r1ZhiLP+JTnV2w=PgWTHgW6KbcPuactc6Mr9OkSXdERFGMtg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 09:25:01AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> ERROR: "obd_memory"
> [drivers/staging/lustre/lustre/obdclass/obdclass.ko] undefined!
> make[1]: *** [__modpost] Error 1

You are bit slower than the 0-day bot, the proper developers have
already been notified of this :)

thanks,

greg k-h
