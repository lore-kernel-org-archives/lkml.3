Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaFBUmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:42:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36573 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaFBUmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:42:03 -0400
Date: Mon, 02 Jun 2014 13:42:02 -0700 (PDT)
Message-Id: <20140602.134202.1698804173611261708.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.15-rc8 ... and merge window for 3.16
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwv+xSrNeZJ_CP7HFxPPKWehZ09uDP3McfzWEEjM00SLg@mail.gmail.com>
References: <CA+55aFwSLmJ1kLO-zNm944Q-=oYYH2Lo0W14Dn0mbj91V5MNFA@mail.gmail.com>
	<538CC855.4080201@mit.edu>
	<CA+55aFwv+xSrNeZJ_CP7HFxPPKWehZ09uDP3McfzWEEjM00SLg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 13:42:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jun 2014 12:01:49 -0700

> On Mon, Jun 2, 2014 at 11:54 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> AFAIK, Zebra is still broken on 3.15.  Should something like this be
>> applied:
>>
>> http://article.gmane.org/gmane.linux.kernel.stable/91782
> 
> Ahh, yes. I thought it went into the networking tree already, but I'm
> not seeing it there. Adding Davem to the cc to see what the situation
> is.

I'm working through my backlog and you will have this by the end of a
day via a pull request.
