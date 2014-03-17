Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaCQHmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:42:49 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:31380 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932124AbaCQHmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:42:47 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-7.tower-178.messagelabs.com!1395042162!32287851!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 17 Mar 2014 08:42:43 +0100
Date: Mon, 17 Mar 2014 08:42:38 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: Borislav Petkov <bp@alien8.de>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        <dougthompson@xmission.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC: remove deprecated IRQF_DISABLED
Message-ID: <20140317074237.GA3086@jtlinux>
References: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20131014095602.GA14274@jtlinux>
 <5316B065.7070104@free-electrons.com>
 <20140305064915.GA28317@pd.tnic>
 <531AA766.3050309@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <531AA766.3050309@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 06:15:18AM +0100, Michael Opdenacker wrote:
> On 03/05/2014 07:49 AM, Borislav Petkov wrote:
> > On Wed, Mar 05, 2014 at 06:04:37AM +0100, Michael Opdenacker wrote:
> >> My patch still applies to 3.14-rc5, which means that mpc85xx_edac is
> >> still there.
> >>
> >> I'd like to get rid of this patch for good ;)
> > Something like that, right:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/commit/?id=e245e3b25f9ef33b166f0f01d19d6418f52ae726
> >
> > ?
> >
> > Its on its way upstream.
> Great, thank you for the good news!
>
> Cheers,
>
> Michael.
>
> --
> Michael Opdenacker, CEO, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
> +33 484 258 098
>

Sorry for not answering you, but I was out of office. As boris told you already, it's on its way.

Johannes
