Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab3EGGvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:51:22 -0400
Received: from hell.mpoli.fi ([62.236.108.11]:40589 "EHLO hell.mpoli.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab3EGGvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:51:21 -0400
X-Greylist: delayed 3004 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 02:51:21 EDT
Date: Tue, 7 May 2013 08:59:25 +0300 (EEST)
From: Kim Enkovaara <embo@mpoli.fi>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Rob Landley <rob@landley.net>,
        Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        James Courtier-Dutton <james.dutton@gmail.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        David Goodenough <david.goodenough@btconnect.com>,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
In-Reply-To: <20130506203118.GK28282@csclub.uwaterloo.ca>
Message-ID: <alpine.LRH.2.02.1305070852570.26919@hell.mpoli.fi>
References: <CAPweEDwZrXQ4Wqw6_-YvmR7uNxWWNvE_c0-8UMuEhFzYW-BZWQ@mail.gmail.com> <1367870518.18069.211@driftwood> <20130506203118.GK28282@csclub.uwaterloo.ca>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013, Lennart Sorensen wrote:

> I am getting the impression that we should ignore the cell phones given
> they seem to be thoroughly ignoring their customers and everyone else
> anyhow.  If we then focus on the devices that perhaps do care to be around
> for a while and supported, we might actually have a manageable problem.
> Who knows maybe at some point the cell phone makers will smarted up and
> realize there is a market in having happy long term customers and join in.

ARM based SoC chips are quickly coming to industrial, automotive and 
telecom markets. On those markets maintainability is important, also the 
volumes are always not that great, and software engineers are a limited 
resource. There will be even some chips where the peripherials are the 
same in the SoC, just the core can be selected ARM vs. PPC for example and 
PPC side already uses DT.

Regards,
--Kim
