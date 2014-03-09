Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaCIGBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 01:01:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCIGBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 01:01:24 -0500
Date: Sat, 8 Mar 2014 22:02:00 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arjan van de Ven <arjanvandeven@gmail.com>
Cc: Roland Dreier <roland@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, shli@kernel.org
Subject: Re: [PATCH] Revert "driver core: synchronize device shutdown"
Message-ID: <20140309060200.GA28471@kroah.com>
References: <1393991871-1743-1-git-send-email-roland@kernel.org>
 <20140305040929.GA31130@kroah.com>
 <CAG4TOxONSsyokdy9Sw+fT21QA7E-uY572ZDoNf3V9f7D1ytyxQ@mail.gmail.com>
 <20140305043858.GA2494@kroah.com>
 <CADyApD0hi3QoTPNoJKi0k-MQdF557BkU=MfBNDgUiAxPGfJ_Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyApD0hi3QoTPNoJKi0k-MQdF557BkU=MfBNDgUiAxPGfJ_Cg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:30:49PM -0800, Arjan van de Ven wrote:
> >> AFAICT the synchronization does nothing useful and is just a remnant
> >> of a patch series where the real meat didn't get applied.  But of
> >> course it would be great if Shaohua could confirm my understanding.
> >
> > Shaohua's email address seems to now bounce :(
> >
> > Arjan, any thoughts?
> 
> 
> if there are no users, it should go... all it does it slows down the shutdown.

Ok, thanks, will revert it.
