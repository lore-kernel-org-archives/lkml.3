Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaBCJlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:41:36 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:25218 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbaBCJle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:41:34 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-4.tower-194.messagelabs.com!1391420329!8509252!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 03 Feb 2014 10:38:49 +0100
Date: Mon, 3 Feb 2014 10:38:43 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Borislav Petkov <bp@alien8.de>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>, <bp@suse.de>,
        <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac/85xx: Remove deprecated IRQF_DISABLED
Message-ID: <20140203093843.GA19225@jtlinux>
References: <1390293747-11185-1-git-send-email-johannes.thumshirn@men.de>
 <20140203070404.GA32443@jtlinux>
 <20140203093458.GA22608@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140203093458.GA22608@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:34:58AM +0100, Borislav Petkov wrote:
> On Mon, Feb 03, 2014 at 08:04:06AM +0100, Johannes Thumshirn wrote:
> > Boris, Mauro:
> >
> > Ping?
>
> No worries, I saw your patch. But in the future, please hold off from
> sending any patches during the merge window unless it is a serious
> regression to code already upstream.
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

OK, sorry
