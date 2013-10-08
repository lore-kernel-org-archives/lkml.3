Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3JHR4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:56:34 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:51967 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab3JHR4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:56:32 -0400
Date: Tue, 8 Oct 2013 19:59:49 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
Message-ID: <20131008195949.0673f83e@armhf>
In-Reply-To: <20131008161145.GJ5402@titan.lakedaemon.net>
References: <20130828113521.35c53365@armhf>
	<521DCD80.9010105@gmail.com>
	<20130831125128.0e3a23c7@armhf>
	<140d8d8a23f.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com>
	<20130926101147.217015e1@armhf>
	<5243F0CE.9000301@gmail.com>
	<20130926132859.04ad4407@armhf>
	<5246E747.6020103@gmail.com>
	<20131003181716.6d03d576@armhf>
	<20131008161145.GJ5402@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Oct 2013 12:11:45 -0400
Jason Cooper <jason@lakedaemon.net> wrote:

> Jean-Francois,
> 
> On Thu, Oct 03, 2013 at 06:17:16PM +0200, Jean-Francois Moine wrote:
> > It seems that my patch about adding s/pdif to the kirkwood audio driver
> > has not been accepted yet...
> 
> Looking over that conversation does not give the impression that
> concerns were resolved.  I'm a little short on time atm, all I can add
> definitively is that I agree with Thomas wrt the compatible strings.
> They should be named after the first compatible IP block (in this case,
> kirkwood).
> 
> Please submit a fix for v3.12-rc cleaning up what Mark Brown accepted so
> we don't have to maintain it indefinitely, and we'll see if we can work
> out the rest in fairly short order.  Posting a new version of series
> would help kick off that conversation... ;-)

Jason,

Thank you, I had forgotten this patch series. New submit done.

As it is a new development, it may go to 3.13. The compatible string
has been updated by Thomas and it is present in 3.12-rc1.

In my quoted message, I was thinking about the patch:

[PATCH] ASoC: kirkwood: add S/PDIF support

dated 24 Sep 2013.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
