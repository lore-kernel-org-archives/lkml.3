Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710AbaDVSA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:00:58 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48589 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933553AbaDVSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:00:18 -0400
Date: Tue, 22 Apr 2014 13:59:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Colin King <colin.king@canonical.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8188ee: initialize packet_beacon
Message-ID: <20140422175919.GC16193@tuxdriver.com>
References: <1398098324-5193-1-git-send-email-colin.king@canonical.com>
 <53555240.70806@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53555240.70806@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 12:15:44PM -0500, Larry Finger wrote:
> On 04/21/2014 11:38 AM, Colin King wrote:
> >From: Colin Ian King <colin.king@canonical.com>
> >
> >static code analysis from cppcheck reports:
> >
> >[drivers/net/wireless/rtlwifi/rtl8188ee/trx.c:322]:
> >   (error) Uninitialized variable: packet_beacon
> >
> >packet_beacon is not initialized and hence packet_beacon
> >contains garbage from the stack, so set it to false.
> >
> >Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >---
> >  drivers/net/wireless/rtlwifi/rtl8188ee/trx.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This change should have a "Cc: Stable <stable@vger.kernel.org> [3.10+] notation.
> 
> Other than that, Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> John: Is it possible for you to add stable, or do you want Colin to resubmit.

Got it, thanks...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
