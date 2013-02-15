Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935174Ab3BOACd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 19:02:33 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56203 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759679Ab3BOACb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 19:02:31 -0500
X-Sasl-enc: +Yr3oDe0SC2F+ipWhUjs4U0aAF+O6ECdda/KLiN/TGhU 1360886550
Date: Thu, 14 Feb 2013 16:02:29 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Joe Millenbach <jmillenbach@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Feb 13 (virtio_console)
Message-ID: <20130215000229.GA5164@kroah.com>
References: <20130213193532.162080d7c0557a307ab451ac@canb.auug.org.au>
 <511BEC55.5090801@infradead.org>
 <87sj4zk3ai.fsf@rustcorp.com.au>
 <511D30B4.5020201@infradead.org>
 <511D330A.2050407@infradead.org>
 <20130215105519.1d8de65d4f9195eeb9306c13@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215105519.1d8de65d4f9195eeb9306c13@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 10:55:19AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> The patch below is needed in the tty tree (which introduced CONFIG_TTY).

Ok, now done.

> Also, has someone checked to see if any of the CONFIG_ symbols that had a
> dependency on TTY added are selected anywhere else?

Joe did all of that I think.  Joe?

