Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaCBTtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 14:49:23 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46200 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaCBTtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 14:49:22 -0500
MIME-Version: 1.0
In-Reply-To: <201403021327.46706.gheskett@wdtv.com>
References: <201403021327.46706.gheskett@wdtv.com>
Date: Sun, 2 Mar 2014 14:49:21 -0500
X-Google-Sender-Auth: D5WMYlhFxBNOOicMCt-VjwmgaTU
Message-ID: <CAKb7UvhYPdOYFA3KzJMMBcUN061Suz2EbUwS0bgJoerJ6LOkSQ@mail.gmail.com>
Subject: Re: Turn off the bubble machine.
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Gene Heskett <gheskett@wdtv.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2014 at 1:27 PM, Gene Heskett <gheskett@wdtv.com> wrote:
> Greetings;
>
> Something is stuck in a loop someplace and I am now being bombarded by
> reject messages from:
>
> Hi. This is the qmail-send program at mail.wdtv.com.
> I'm afraid I wasn't able to deliver your message to the following
> addresses.
> This is a permanent error; I've given up. Sorry it didn't work out.
>
> <imirkin@alum.mit.edu>:
> CNAME lookup failed temporarily. (#4.4.3)
> I'm not going to try again; this message has been in the queue too long.
>
> --- Below this line is a copy of the message.
>
> Return-Path: <gheskett@wdtv.com>
> Received: (qmail 13855 invoked by uid 509); 23 Feb 2014 09:12:26 -0500
> Received: from xxx.xxx.xxx.xxx (gheskett@wdtv.com@xxx.xxx.xxx.xxx) by
> mail.wdtv.com (envelope-from <gheskett@wdtv.com>, uid 508) with qmail-
> scanner-2.01
>  (clamdscan: 0.88.7/2478. spamassassin: 3.1.7.
>  Clear:RC:0(xxx.xxx.xxx.xxx):SA:0(1.6/5.0):.
>  Processed in 0.58892 secs); 23 Feb 2014 14:12:26 -0000
> X-Spam-Status: No, score=1.6 required=5.0
> X-Spam-Level: +
> Received: from unknown (HELO coyote.localnet)
> (gheskett@wdtv.com@xxx.xxx.xxx.xxx)
>   by mail.wdtv.com with SMTP; 23 Feb 2014 09:12:26 -0500
> From: Gene Heskett <gheskett@wdtv.com>
> To: Mike Galbraith <bitbucket@online.de>
> Subject: Re: It BOOTS! 3.13.5 that is.
> Date: Sun, 23 Feb 2014 09:12:18 -0500
> Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
>  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> References: <201402222022.20370.gheskett@wdtv.com>
> <1393135859.30960.8.camel@marge.simpson.net>
> <201402230803.31091.gheskett@wdtv.com>
> In-Reply-To: <201402230803.31091.gheskett@wdtv.com>
> MIME-Version: 1.0
> Content-Type: Text/Plain;
>   charset="windows-1256"
> Content-Transfer-Encoding: 7bit
> Message-Id: <201402230912.19049.gheskett@wdtv.com>
>
> I am getting about 2 or 3 of these a day. Since about 24 hours after this
> original posting.  So Ilia Mirkin <imirkin@alum.mit.edu>, please do
> whatever it takes to stop this.

Sounds like an issue on your end, TBH (or rather, mail.wdtv.com).
alum.mit.edu is not a CNAME and has its own MX records (which in turn
point to A records). I'm not aware of anyone else with this problem
(or at least they haven't told me about it). In any case, I have no
control over alum.mit.edu. If you earnestly believe that it's
something wrong on the MIT end (and I'm _fairly_ sure it's not, based
on the message you sent), you can try contacting noc@mit.edu.

Cheers,

  -ilia
