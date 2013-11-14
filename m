Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3KNOVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:21:41 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.116]:8136 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab3KNOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:21:35 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-7.tower-194.messagelabs.com!1384438891!9325988!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.13; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 14 Nov 2013 15:21:32 +0100
Date: Thu, 14 Nov 2013 15:21:25 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Borislav Petkov <bp@alien8.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Robert Richter <rric@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [GIT PULL] mpc85xx_edac changes for 3.13
Message-ID: <20131114142125.GA29214@jtlinux>
References: <20131112161901.GA15637@jtlinux>
 <CA+55aFzJhyo8bKBchYq0Q=rwPv_-v-xWgOKWxKBcSBycMZcmTg@mail.gmail.com>
 <20131114054750.GA27791@kroah.com>
 <20131114092009.GA4960@pd.tnic>
 <20131114091843.4bb72afc@samsung.com>
 <20131114112418.GH4960@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131114112418.GH4960@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 14 Nov 2013 14:21:31.0033 (UTC) FILETIME=[D0607090:01CEE144]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 12:24:18PM +0100, Borislav Petkov wrote:
> On Thu, Nov 14, 2013 at 09:18:43AM -0200, Mauro Carvalho Chehab wrote:
> > So, in practice, Borislav was working as a maintainer for amd64 EDAC
> > patches, and I working mainly as Intel EDAC maintainer. The (few)
> > other arm EDAC patches were either coming via my tree or via Boris
> > tree, depending on who got them first.
>
> Yeah, and I think this has worked pretty good in the past so if you want
> to, we can continue the same thing of sharing the load on EDAC patches
> and we both do interim maintainers until Doug steps in.
>
> And since it won't change any workflow for Linus, he's probably fine
> with it too.
>
> Yes, no? Comments?

OK for me. For the MPC85xx EDAC I'll do the testing then and either Borislav or
Mauro send them upstream.

Regards,
	Johannes
