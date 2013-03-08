Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab3CHIIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 03:08:53 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15288 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610Ab3CHIIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 03:08:52 -0500
From: <oskar.andero@sonymobile.com>
Date: Fri, 8 Mar 2013 09:08:48 +0100
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        "Enderborg, Peter" <Peter.Enderborg@sonymobile.com>,
        "arve@android.com" <arve@android.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] lowmemorykiller: Use ktimer instead of jiffies
Message-ID: <20130308080847.GA19509@caracas.corpusers.net>
References: <1362652359-23779-1-git-send-email-oskar.andero@sonymobile.com>
 <20130307172520.GA484@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130307172520.GA484@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:25 Thu 07 Mar     , Greg KH wrote:
> On Thu, Mar 07, 2013 at 11:32:39AM +0100, oskar.andero@sonymobile.com wrote:
> > From: Peter Enderborg <peter.enderborg@sonymobile.com>
> > 
> > Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> > Signed-off-by: Peter Enderborg <peter.enderborg@sonymobile.com>
> > Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> > ---
> 
> No changelog entry saying why you want this change?  You need to explain
> this, otherwise I'll assume it's not needed at all, and just drop it...

Point taken. I will update the commit message.

Thanks!

-Oskar
