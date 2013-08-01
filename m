Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab3HAW10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:27:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3HAW1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:27:24 -0400
Date: Fri, 2 Aug 2013 06:28:40 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Evan Ng <evan.sin.ng@gmail.com>
Cc: pe1dnn@amsat.org, johanmeiring@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlags49_h2: fixed 80 line character and white
 space issue in ap_h2.c Fixed various coding style warnings found by the
 checkpatch.pl tool
Message-ID: <20130801222840.GA5444@kroah.com>
References: <1375303465-3437-1-git-send-email-evan.sin.ng@gmail.com>
 <20130801215019.GA4427@kroah.com>
 <CAGkkOHezKfjYaGJHcbPPiE4EobOLMp=K62-NWhpbvp2QDhLOfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGkkOHezKfjYaGJHcbPPiE4EobOLMp=K62-NWhpbvp2QDhLOfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:08:21PM -0700, Evan Ng wrote:
> Thanks for the reply, 
> 
> Being this is my first patch that I have submitted, I want to clarify a few
> things:
> 
> My *corrected* subject should read something like this? 
> 
> "Subject: [PATCH] Staging: wlags49_h2: fixed 80 line character and white space
>                issue in ap_h2.c Fixed various coding style warnings found by
> the
>                checkpatch.pl tool
> \n
> LONGER DESCRIPTION GOES HERE"

No.

It should be:
	Subject: [PATCH] Staging: wlags48_h2: ap_h2.c: fixed tab whitespace issue

	This patch fixes the tab vs. spaces white space issues in this
	file.

	Signed-off-by: ....

> As for the doing "one thing at a time" would it be preferred if I fix the
> syntax of one function within a file a time?  Would that mean that for one
> simple .c file I could be making 15 or so commits to it?

How about fixing one specific warning at a time for the whole file?
Like tab issues, and then { issues, and then ' ' issues, and so on.  See
the archives of the mailing list for lots of examples of how to do this
properly.

hope this helps,

greg k-h
