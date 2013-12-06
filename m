Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3LFSjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:39:42 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55953 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757793Ab3LFSjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:39:40 -0500
X-Sasl-enc: EkB7k9VMh38Wto0NmfwiGTyx9XY+0sUvl1TBOzMZoXtC 1386355171
Date: Fri, 6 Dec 2013 10:39:30 -0800
From: Greg KH <greg@kroah.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Subject: Re: Nov. Fedora Kernel Patch Report
Message-ID: <20131206183930.GC4379@kroah.com>
References: <CA+5PVA6Mh=tRM5h=TCbg5yjkkFUg2OncJmHBdtBhG7jqf377rg@mail.gmail.com>
 <CA+5PVA4pXtXHWzeSnx7d9eGEiOQ-jtL2RtBEyqxmz2DemT--jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4pXtXHWzeSnx7d9eGEiOQ-jtL2RtBEyqxmz2DemT--jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 06:56:24PM -0500, Josh Boyer wrote:
> > drm-radeon-24hz-audio-fixes.patch (rhbz 1010679)
> > - Should be in 3.13
> 
> Commits 908171aa738b5bbcc6241cec46f73fcd57dd00d4 and
> 05e4776357fe7217e531cbaaa163e24f688d10ce

These commits don't match anything in Linus's tree, are you sure they
are correct?

thanks,

greg k-h
