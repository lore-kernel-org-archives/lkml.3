Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215AbaFCVjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:39:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934374AbaFCVjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:39:12 -0400
Date: Tue, 3 Jun 2014 14:42:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        Andrea Merello <andrea.merello@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>
Subject: Re: [PATCH 2/4] Staging: rtl8192u: r8192U_wx.c Removed all C99
 comments
Message-ID: <20140603214251.GA19925@kroah.com>
References: <1401725505-3459-1-git-send-email-c@24.io>
 <1401725505-3459-2-git-send-email-c@24.io>
 <CAMuHMdW1YnLVyZbmD0fadc6KX=EcH4CArC1379CDGb9ACm=GbQ@mail.gmail.com>
 <20140603183644.GG15585@mwanda>
 <CADadk9HSKT3+wtBbOEiMB2ZirikNF2D71Zw6Jy+A1CCNHwXiTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADadk9HSKT3+wtBbOEiMB2ZirikNF2D71Zw6Jy+A1CCNHwXiTA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 02:34:55PM -0700, Chaitanya Hazarey wrote:
> On Tue, Jun 3, 2014 at 11:36 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > It always feels much better after the dead code is gone.
> 
> So patches are still good ? No change required for my side, right ? I
> just need to wait for Greg's needle to come to this point and pick
> them up.

That will be a few weeks, as the merge window is open so I can't take
anything in my tree until 3.16-rc1 is out.  So keep working on things,
these aren't lost, I'll get to them in a few weeks.

thanks,

greg k-h
