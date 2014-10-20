Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaJTVhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:37:41 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:41927 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaJTVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:37:39 -0400
Date: Tue, 21 Oct 2014 00:37:31 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Balbi <balbi@ti.com>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141020213731.GC28144@drone.musicnaut.iki.fi>
References: <20141019090107.GA19132@amd>
 <20141019100739.GA2547@amd>
 <20141019152414.GB5189@saruman>
 <20141019191937.GA6438@amd>
 <20141020213518.GB28144@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020213518.GB28144@drone.musicnaut.iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 21, 2014 at 12:35:18AM +0300, Aaro Koskinen wrote:
> On Sun, Oct 19, 2014 at 09:19:37PM +0200, Pavel Machek wrote:
> > I am trying to use nfsroot, so I can't use modules.
> 
> Why not?
> 
> > (I am attaching full config, in case I missed something important).
> 
> I'm using the below config with 3.17 and g_ether works OK.

Also, I'm using DT boot.

A.
