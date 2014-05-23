Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaEWJWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:22:39 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54582 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaEWJWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:22:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] ARM: remove last use of CONFIG_CPU_ARM710
Date: Fri, 23 May 2014 11:22:25 +0200
Message-ID: <4338460.K64agCvt26@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400836074.31526.14.camel@x220>
References: <1364507176.1345.45.camel@x61.thuisdomein> <4305975.PvMXZQ020k@wuerfel> <1400836074.31526.14.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WSohKupXMCHOAuOJ5Eh8fxdDQaCh8ziA+L73lHcLV1c
 8mec3Lk6f6nTEgH6PAxFF+Fch2Shhkc4diKetW3Q2o3lST8MAx
 vDBGcqIzNmfspmMlgJHDT+UTVWVaGRWtPao39IApW2u8xgQk/X
 4pWMDspCVgQQPfCE8MUjg26p5g722XjyTy+SNJcs3EdsDvF++r
 PiTMlWDOSGBiPMV3CFQ/ztUtpXMGPSq7mI+bEHy+GpC+p4x8IN
 Ll1RXinA/8UIdEp8PSnlZInJd5tktEVROgxVsMWIekG3HB5S/k
 iZoH1C7ROUjDL9jh4L33XuJoPY3xxjtZZLVIlW6RoCJXpFerlf
 vt7XLG36+Ut1vkDZcMvQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014 11:07:54 Paul Bolle wrote:
> On Wed, 2014-05-14 at 11:28 +0200, Arnd Bergmann wrote:
> > On Wednesday 14 May 2014 11:25:50 Paul Bolle wrote:
> > > On Wed, 2014-05-14 at 11:17 +0200, Arnd Bergmann wrote:
> > > > 'git grep -i arm710' tells me that there is also some arm710
> > > > specific code in  arch/arm/mm/proc-arm720.S that we may want to
> > > > remove along with this.
> > > > 
> > > > The DT binding should probably remain untouched though, I think it's
> > > > correct to document the string.
> > > 
> > > That seems to be cpu_arm710_name, __arm710_setup, and everything called
> > > by __arm710_setup. Cleaning that up (as a separate patch) appears to be
> > > trivial. If I do that it would be (sort of educated) guesswork. But I
> > > don't mind doing it. What do you prefer?
> > 
> > I think that would be great. For the first patch, please add 
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Once the second patch is reviewed, please add them both to Russell's
> > patch tracker.
> 
> Well, at least that second patch triggered a nice conversation. So I
> should now add the first patch (with your ACK) to the tracker?

Yes, please do that.

	Arnd
