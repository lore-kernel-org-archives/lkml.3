Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaIWUPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:15:23 -0400
Received: from 78.218.17.109.rev.sfr.net ([109.17.218.78]:53008 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753540AbaIWUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:15:20 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 16:15:19 EDT
Date: Tue, 23 Sep 2014 22:07:52 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Joe Perches <joe@perches.com>
Cc: Mark Einon <mark.einon@gmail.com>, Tobias Klauser <tklauser@distanz.ch>,
        gregkh@linuxfoundation.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH linux-next] et131x: Promote staging et131x driver to
 drivers/net
Message-ID: <20140923200752.GA23375@electric-eye.fr.zoreil.com>
References: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
 <20140923072251.GD4657@distanz.ch>
 <20140923094614.GA5130@leicester.auvation.com>
 <20140923190242.GA8096@electric-eye.fr.zoreil.com>
 <1411499875.29268.7.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411499875.29268.7.camel@joe-AO725>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> :
> On Tue, 2014-09-23 at 21:02 +0200, Francois Romieu wrote:
[...]
> > How about kernel tinification ?
> 
> The tiny case where a large number of ethernet drivers are included?

No.

A couple of bytes here and there vs a cosmetic kernel wide change.

-- 
Ueimor
