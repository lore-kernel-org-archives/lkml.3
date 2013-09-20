Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3ITOpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 10:45:14 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58083 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3ITOpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:45:12 -0400
Date: Fri, 20 Sep 2013 16:45:08 +0200
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Greg KH <gregkh@linuxfoundation.org>, harsh1kumar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/24] Staging: winbond: reg: seventh of the patches
 that fixes lines over 80 characters
Message-Id: <20130920164508.ec1ab4101bcc3c77396c943d@gmail.com>
In-Reply-To: <20130917094326.GO19256@mwanda>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
	<1379339024-12157-16-git-send-email-ikerpedrosam@gmail.com>
	<CANBXnMm7QCab3cU4NMzmA3OjXckcUx5dakyD_TRwfj3j2_02MA@mail.gmail.com>
	<20130917094326.GO19256@mwanda>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013 12:43:26 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Tue, Sep 17, 2013 at 02:29:22PM +0530, Adil Mujeeb wrote:
> > Hi,
> > 
> > 
> > >-       PowerData = (1 << 31) | (0 << 30) | (24 << 24) |
> > BitReverse(w89rf242_txvga_data[i][0], 24);
> > >+       PowerData = (1 << 31) | (0 << 30) | (24 << 24)
> > >+                           | BitReverse(w89rf242_txvga_data[i][0], 24);
> > .....
> > .....
> > 
> > >-       reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) |
> > (DEFAULT_LONG_RETRY_LIMIT << 4) | DEFAULT_SHORT_RETRY_LIMIT;
> > >+       reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) |
> > >+                                      (DEFAULT_LONG_RETRY_LIMIT << 4) |
> > >+                                      DEFAULT_SHORT_RETRY_LIMIT;
> > 
> > I think consistency is needed. Either break the lines putting the OR
> > operator ( | ) at the start of new line or at the end of each line. People
> > has its own preference but here you have used both style in single file.
> > Just a suggestion.
> > 
> 
> Put the '|' character at the end of the line.  That's the New Unwritten
> Style Guidelines.  Most of the kernel does it this way and it's easier
> to read.
> 
> But this could be fixed in a later patch instead of redoing the whole
> series.
> 
> regards,
> dan carpenter
> 

I will change it for the new version of this patch but I want to wait some days until everybody looks the patches that I've sent.


-- 
Regards,

Iker Pedrosa <ikerpedrosam@gmail.com>
