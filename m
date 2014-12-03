Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaLCAyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:54:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaLCAyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:54:07 -0500
Date: Tue, 2 Dec 2014 16:54:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Fred <fred.chou.nd@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: rt8192u: fix sparse warnings in r8192U_core.c
Message-ID: <20141203005407.GA4433@kroah.com>
References: <1417398885-27038-1-git-send-email-fred.chou.nd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417398885-27038-1-git-send-email-fred.chou.nd@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:54:45AM +0800, Fred wrote:
> Fixed the following warnings in sparse:
> drivers/staging/rtl8192u/r8192U_core.c:670:6: warning:
>  	symbol 'dump_eprom' was not declared.
> 	Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:1489:5: warning:
>  	symbol 'ComputeTxTime' was not declared.
> 	Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:1556:14: warning:
> 	symbol 'txqueue2outpipe' was not declared.
> 	Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:4876:5: warning:
> 	symbol 'GetRxPacketShiftBytes819xUsb' was not declared.
> 	Should it be static?
> 
> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8192U_core.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Your From: line does not match your "Signed-off-by:" line, so I can't
take this :(

