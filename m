Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaIOTAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:00:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44079 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaIOTAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:00:11 -0400
Date: Mon, 15 Sep 2014 14:56:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-09-14
Message-ID: <20140915185659.GD3891@tuxdriver.com>
References: <20140914041912.GA1623@t440s.P-661HNU-F1>
 <20140914042427.GA1926@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914042427.GA1926@t440s.P-661HNU-F1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 07:24:27AM +0300, Johan Hedberg wrote:
> Hi John,
> 
> On Sun, Sep 14, 2014, Johan Hedberg wrote:
> > Here are some more patches intended for 3.18. Most of them are cleanups
> > or fixes for SMP. The only exception is a fix for BR/EDR L2CAP fixed
> > channels which should now work better together with the L2CAP
> > information request procedure.
> > 
> > Let me know if there are any issues pulling. Thanks.
> > 
> > Johan
> > 
> > ---
> > The following changes since commit 39e90c77637b3892a39f2908aea57539e961c50e:
> > 
> >   Bluetooth: 6lowpan: Route packets that are not meant to peer via correct device (2014-09-09 15:51:47 +0200)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
> 
> This was supposed to be a reference to the for-upstream branch instead
> of master. Both point to the same commit at this moment but it'd be more
> convenient if you pull from for-upstream so that the master branch can
> continue living on without waiting for the pull to happen. Sorry for the
> extra hassle.
> 
> Johan

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
