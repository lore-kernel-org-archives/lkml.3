Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaE2V73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:59:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaE2V72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:59:28 -0400
Date: Thu, 29 May 2014 15:03:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chaitanya Hazarey <c@24.io>, Andrea Merello <andrea.merello@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>
Subject: Re: [PATCH 1/2] Staging: rtl8192u: r8192U_wx.c Fixed a misplaced
 brace
Message-ID: <20140529220304.GB22685@kroah.com>
References: <1401319428-20798-1-git-send-email-c@24.io>
 <20140529204317.GA9865@kroah.com>
 <CADadk9E3bhsr9_f13ugQNX_mtX1c4a5DM2=+ZVK76QUb+FAePg@mail.gmail.com>
 <20140529210051.GA21250@kroah.com>
 <20140529214115.GC15585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529214115.GC15585@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 12:41:15AM +0300, Dan Carpenter wrote:
> On Thu, May 29, 2014 at 02:00:51PM -0700, Greg KH wrote:
> > On Thu, May 29, 2014 at 01:43:01PM -0700, Chaitanya Hazarey wrote:
> > > I have 1/5 through to 5/5. Will resend rightaway with slightly changed
> > > subjects.
> > 
> > What does that have to do with patch 2/2 here?  You sent a 1/2 patch, so
> > obviously there should be a 2/2 somewhere...
> > 
> > confused,
> 
> Heh.  You recieved [patch 2/2] but you didn't like it.
> https://lkml.org/lkml/2014/5/28/818

Ah.  Remember, I have the short-term memory of a squirrel.  I reviewed
some 1500+ patches in the past 2 days, I can't remember my name at the
moment...

> Meanwhile Chaitanya keeps resending these patches over and over so now
> I have around 5 million of them in my inbox.  Calm down, Chaitanya!
> Give us a little time to catch up before you resend.

Yes, please give us a chance to catch up...

greg k-h
