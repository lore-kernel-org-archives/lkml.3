Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3E0BzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:55:13 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59464 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab3E0BzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:55:12 -0400
Message-ID: <51A2BCE6.806@ahsoftware.de>
Date: Mon, 27 May 2013 03:54:46 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: Fredrik Tolf <fredrik@dolda2000.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Weird disk idling
References: <alpine.DEB.2.02.1305260712220.8957@shack.dolda2000.com>
In-Reply-To: <alpine.DEB.2.02.1305260712220.8957@shack.dolda2000.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.05.2013 07:29, schrieb Fredrik Tolf:

> I'm sure you all know what the various fields are (except the first,

Hmm, I had to look at Documentation/block/stat.txt.

> which is just a timestamp), so as you can see, there are 135 requests in
> the queue, but no reads or writes happen, in this case, for at least 800
> ms.
> 
> Is this behavior normal and expected, or is there something wrong here?
> In the latter case, is it my hardware that is failing somehow, or can
> there be some software weirdness that can be tweaked away or bugfixed?

I would say thats how caches do work. You might have a look at

sysctl vm

which shows a lot of the knobs you can turn to change some of the
aspects you see.

Regards,

Alexander Holler
