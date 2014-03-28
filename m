Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaC1IoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:44:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaC1IoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:44:12 -0400
Date: Fri, 28 Mar 2014 01:46:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Insop Song <Insop.Song@gainspeed.com>
Cc: "insop.song@gmail.com" <insop.song@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Remove warning printk
Message-ID: <20140328084604.GA29100@kroah.com>
References: <1395978883-18723-1-git-send-email-insop.song@gainspeed.com>
 <1395978883-18723-2-git-send-email-insop.song@gainspeed.com>
 <20140328064926.GB13510@kroah.com>
 <e575184bc64e46b9b5e229cec5338030@BY2PR07MB011.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e575184bc64e46b9b5e229cec5338030@BY2PR07MB011.namprd07.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 08:05:23AM +0000, Insop Song wrote:
> Hi Greg,
> 
> Will send out a new patch mail with single patch shortly.
> 
> I have not yet find a good way to reply mail and add patch yet with my mailing server/client.
> 
> That's why I send out a separate email instead of replying to Arnd.
> 
> Below is his email and it has his signed-off, that's why I put that in my patch you got.

But Arnd wrote the patch, not you.  Why are you claiming credit for it?

You also changed the subject.  Not good.

I'll just take Arnd's original patch, when my merge window opens back up
again (after 3.15-rc1), and add your signed-off-by to the patch.  You
can just reply to Arnd's patch with that line, and I will add it.

Don't strip off ownership of the patch, if you are having email
problems, read Documenation/SubmittingPatches for how to get the
authorship right.

greg k-h
