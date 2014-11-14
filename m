Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422964AbaKNXZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:25:36 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34630 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422933AbaKNXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:25:34 -0500
Date: Fri, 14 Nov 2014 15:25:30 -0800
From: josh@joshtriplett.org
To: Pieter Smith <pieter@boesman.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 51/56] drivers/char/mem: support compiling out splice
Message-ID: <20141114232530.GA4378@cloud>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-52-git-send-email-pieter@boesman.nl>
 <20141113220911.GA546@kroah.com>
 <CAPho-_JJGy0cwBVfWKL1Gt9ZQZM+Odo7W05bKQ2JLO+TM-ABJA@mail.gmail.com>
 <20141113223150.GB30412@cloud>
 <20141113233416.GC7678@kroah.com>
 <20141114001948.GA30946@cloud>
 <20141114032722.GA31174@kroah.com>
 <CAPho-_KUc-+c=X6xtLTD2F-o4qi+YpYdnw6F1cx4kniezfs7aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPho-_KUc-+c=X6xtLTD2F-o4qi+YpYdnw6F1cx4kniezfs7aw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please don't top-post.]

On Sat, Nov 15, 2014 at 12:11:23AM +0100, Pieter Smith wrote:
> Off course! You are right. Most savings are gained from compiling out
> fs/splice.c. I'll eliminate file-system driver changes as far as possible.
> 
> Turning splice exports into inline NOPs when splice is compiled out should
> keep me out of the file-systems.
> 
> The space savings are scattered over the patch-set. I'll make sure the next
> attempt includes it in the cover-letter.

I'd suggest including the results from scripts/bloat-o-meter in the
cover letter next time.

- Josh Triplett
