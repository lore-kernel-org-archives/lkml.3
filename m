Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3LFThA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:37:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53237 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758208Ab3LFTg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:36:58 -0500
X-Sasl-enc: 4VqUk6pjutvw64b4Fpuix+4xj8nSWvVzouRLZAgcHyYP 1386358613
Date: Fri, 6 Dec 2013 11:36:52 -0800
From: Greg KH <greg@kroah.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Subject: Re: Nov. Fedora Kernel Patch Report
Message-ID: <20131206193652.GB5233@kroah.com>
References: <CA+5PVA6Mh=tRM5h=TCbg5yjkkFUg2OncJmHBdtBhG7jqf377rg@mail.gmail.com>
 <CA+5PVA4pXtXHWzeSnx7d9eGEiOQ-jtL2RtBEyqxmz2DemT--jw@mail.gmail.com>
 <20131206183930.GC4379@kroah.com>
 <CA+5PVA7_iLoeJseApkeTcjch=ONU+ebUPk4G+oUy62mmp2RCTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7_iLoeJseApkeTcjch=ONU+ebUPk4G+oUy62mmp2RCTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 01:43:38PM -0500, Josh Boyer wrote:
> On Fri, Dec 6, 2013 at 1:39 PM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Dec 02, 2013 at 06:56:24PM -0500, Josh Boyer wrote:
> >> > drm-radeon-24hz-audio-fixes.patch (rhbz 1010679)
> >> > - Should be in 3.13
> >>
> >> Commits 908171aa738b5bbcc6241cec46f73fcd57dd00d4 and
> >> 05e4776357fe7217e531cbaaa163e24f688d10ce
> >
> > These commits don't match anything in Linus's tree, are you sure they
> > are correct?
> 
> Sorry, they aren't.  Here are the commits from Linus' tree:
> 
> a2098250fbda149cfad9e626afe80abe3b21e574 drm/radeon/audio: improve ACR
> calculation
> 3e71985f2439d8c4090dc2820e497e6f3d72dcff drm/radeon/audio: correct ACR table

Ah, those work, thanks, now applied.

greg k-h
