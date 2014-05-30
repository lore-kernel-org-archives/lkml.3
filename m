Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaE3VGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:06:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:34321 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaE3VG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:06:29 -0400
Message-ID: <1401483970.14938.38.camel@pasglop>
Subject: Re: Bad DMA from Marvell 9230
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roger Heflin <rogerheflin@gmail.com>
Cc: =?ISO-8859-1?Q?J=E9r=F4me?= Carretero <cJ-ko@zougloub.eu>,
        Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Date: Sat, 31 May 2014 07:06:10 +1000
In-Reply-To: <CAAMCDecAgn=FX4Lw4YK_z4OKZsKqaj3scXe2cg0HN9tSj_FokA@mail.gmail.com>
References: <1395903457.5569.89.camel@pasglop>
	 <20140530030618.5ad4f447@Vantage> <1401446278.14938.26.camel@pasglop>
	 <20140530095822.3588a6ff@Vantage>
	 <CAAMCDecAgn=FX4Lw4YK_z4OKZsKqaj3scXe2cg0HN9tSj_FokA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 09:13 -0500, Roger Heflin wrote:
> Do enough smartcmds and the entire board (all 4 ports) locked up and
> required a reboot, I quit doing smartcmds and stability went way up,
> but it was still not 100% stable.

Any chance you can give me an example of "enough smartcmds" ? IE a
script or something that reliably breaks it for you ? I'd like to try on
my 9235.

Cheers,
Ben.


