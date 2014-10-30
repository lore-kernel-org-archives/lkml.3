Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbaJ3LPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:15:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42460 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759067AbaJ3LPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:15:15 -0400
Date: Thu, 30 Oct 2014 12:15:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH - resend] checkpatch: Remove unnecessary + after {8,8}
Message-ID: <20141030111509.GA11178@pd.tnic>
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712013927.GA30781@kroah.com>
 <1405129612.6751.24.camel@joe-AO725>
 <20140712020114.GA12301@kroah.com>
 <20140712020520.GA18611@kroah.com>
 <1409590506.2614.4.camel@joe-AO725>
 <20141030111204.GA11295@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141030111204.GA11295@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:12:04PM +0100, Borislav Petkov wrote:
> Hey Andrew,
> 
> can we get this one applied already - I'm seeing this warning at least
> since before my summer vacation started! :-P

Oh ok, so it did go in after 3.17 but when using checkpatch on a 3.17
tree, it fires of course. Maybe the first checkpatch fix to tag for
stable?

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
