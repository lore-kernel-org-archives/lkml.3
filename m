Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbbASSzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:55:24 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61725 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbASSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:55:22 -0500
Date: Mon, 19 Jan 2015 10:55:19 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        SF Markus Elfring <elfring@users.sourceforge.net>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Ursula Braun <ursula.braun@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] s390/net: Deletion of unnecessary checks before two
 function calls
Message-ID: <20150119185519.GK9759@ld-irv-0074>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <20141103095059.GL6879@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103095059.GL6879@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I went digging through some of Markus's old patch history, and noticed
this...

On Mon, Nov 03, 2014 at 12:50:59PM +0300, Dan Carpenter wrote:
> This one is buggy.
> 
> I'm sorry, but please stop sending these.

I'm tending to concur.

> For kfree(), at least we all know that kfree() accepts NULL pointer.
> But for this one:
> 1) I don't know what the functions do so I have to look at the code.
> 2) It's in a arch that I don't compile so cscope isn't set up meaning
>    it's hard to find the functions.
> 
> You're sending a lot of patches and they are all hard to review and some
> of them are buggy and none of them really add any value.  It's a waste
> of your time and it's a waste of my time.

And you're still sending buggy patches that exhibit the same qualities.
They're still wasting Dan's time, and now they're wasting mine.

I appreciate automated checkers where they provide added value, but I
really feel you haven't done your diligence on them.

Regards,
Brian
