Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaBQTnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:43:23 -0500
Received: from imap.thunk.org ([74.207.234.97]:59116 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbaBQTnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:43:19 -0500
Date: Mon, 17 Feb 2014 14:43:14 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION v3.14-rc2] NULL dereference in icmp6_send()
Message-ID: <20140217194314.GD16660@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <nsxzjlp4lxm.fsf@closure.thunk.org>
 <20140217185053.GF22833@order.stressinduktion.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217185053.GF22833@order.stressinduktion.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 07:50:53PM +0100, Hannes Frederic Sowa wrote:
> At that point the skb does not have a dst attached, so we panic in
> icmp6_send.
> 
> This is fixed here:
> https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=d94c1f92bbf2c42c5febd68bbea51fffeac90834

Thanks!!

BTW, apologies for the inadvertent share of the photo to my G+ stream.
I had taken the photo using my cell phone, and I was trying to make
sure the URL was publically viewable before I filed the bug report.

					- Ted
