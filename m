Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBJKxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:53:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaBJKw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:52:57 -0500
Date: Mon, 10 Feb 2014 13:52:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>,
        ohaugan@codeaurora.org, Rom Lemarchand <romlem@google.com>,
        devel <devel@driverdev.osuosl.org>, konkers <konkers@android.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ccross@android.com,
        Rebecca Zavin <rebecca@android.com>, prtvar.b@gmail.com
Subject: Re: [PATCH] staging : android : fix checkpatch issues
Message-ID: <20140210105254.GB26776@mwanda>
References: <2067517.LR5DRBeXLF@daeseok-laptop.cloud.net>
 <20140210091135.GR26722@mwanda>
 <CAHb8M2AzdaFLyNkUhU8uTb_ztt3NoEW0QO8px1FRuHdK2cT4FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2AzdaFLyNkUhU8uTb_ztt3NoEW0QO8px1FRuHdK2cT4FA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 07:23:46PM +0900, DaeSeok Youn wrote:
> Thanks for reviewing.
> 
> Yes, I just followed by reports of checkpatch.pl.
> 
> But I don't understand why I can use of seq_puts() in the middle of
> seq_printf() calls.
> I have been trying to search why that is not good but I didn't find
> anything about that.
> And I saw patches which were already merged similar with this patch.
> 
> You can see with this url
> https://github.com/torvalds/linux/commit/2d219c518882d2b2bac77742a6a8979c9dad051a
> https://github.com/mirrors/linux-2.6/commit/7aff38176e79a22b1749c2af74060028298e6a45
> 
> If you don't mind, let me know why it is not good.

Because it doesn't look nice.  It messes up the alignment.

Checkpatch is a tool not a king of the world.  Stop obeying checkpatch.

regards,
dan carpenter

