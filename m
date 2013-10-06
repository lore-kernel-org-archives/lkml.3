Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3JFImJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 04:42:09 -0400
Received: from mout.gmx.net ([212.227.17.20]:65053 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab3JFImF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 04:42:05 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Sun, 06 Oct 2013 10:42:00 +0200
From: "Tibor Billes" <tbilles@gmx.com>
Message-ID: <20131006084200.302560@gmx.com>
MIME-Version: 1.0
Subject: Re: Unusually high system CPU usage with recent kernels
To: paulmck@linux.vnet.ibm.com
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
Content-Transfer-Encoding: 8bit
X-GMX-UID: D0cjclQXeSEqJL5QQHchLP1+IGRvb0A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney Sent: 10/01/13 10:27 PM
> To: Tibor Billes
> Subject: Re: Unusually high system CPU usage with recent kernels
> 
> On Sat, Sep 14, 2013 at 03:59:51PM +0200, Tibor Billes wrote:
> > > From: Paul E. McKenney Sent: 09/13/13 02:19 AM
> > > On Wed, Sep 11, 2013 at 08:46:04AM +0200, Tibor Billes wrote:
> > > > > From: Paul E. McKenney Sent: 09/09/13 10:44 PM
> 
> [ . . . ]
> 
> > > > Sure. The attached tar file contains traces of good kernels. The first is with
> > > > version 3.9.7 (no patch applied) which was the last stable kernel I tried and
> > > > didn't have this issue. The second is version 3.11 with your fix applied.
> > > > Judging by the size of the traces, 3.11.0+ is still doing more work than
> > > > 3.9.7.
> > > 
> > > Indeed, though quite a bit less than the problematic traces.
> > > 
> > > Did you have all three patches applied to 3.11.0, or just the last one?
> > > If the latter, could you please try it with all three?
> > 
> > Only the last one was applied to 3.11.0. The attachement now contains the
> > RCU trace with all thee applied. It seems to be smaller in size, but still
> > not close to 3.9.7.
> > 
> > > > > > I'm not sure about LKML policies about attaching not-so-small files to
> > > > > > emails, so I've dropped LKML from the CC list. Please CC the mailing
> > > > > > list in your reply.
> > > > > 
> > > > > Done!
> > > > > 
> > > > > Another approach is to post the traces on the web and send the URL to
> > > > > LKML. But whatever works for you is fine by me.
> > > > 
> > > > Sending directly to you won again :) Could you please CC the list in your
> > > > reply?
> > > 
> > > Done! ;-)
> > 
> > Could you please CC the list in your reply again? :)
> 
> This trace is quite strange -- there are a number of processes that sleep
> and then wake up almost immediately, as in within a microsecond or so.
> I don't know why they would be doing that, and I also cannot think of
> what RCU might be doing to make them do that.
> 
> I am unfortunately out of ideas on this one.

Okay. Thank you for all your help! :)

Tibor
