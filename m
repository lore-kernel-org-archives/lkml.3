Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3IQJnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:43:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33212 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3IQJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:43:40 -0400
Date: Tue, 17 Sep 2013 12:43:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: Iker Pedrosa <ikerpedrosam@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Greg KH <gregkh@linuxfoundation.org>, harsh1kumar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/24] Staging: winbond: reg: seventh of the patches
 that fixes lines over 80 characters
Message-ID: <20130917094326.GO19256@mwanda>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
 <1379339024-12157-16-git-send-email-ikerpedrosam@gmail.com>
 <CANBXnMm7QCab3cU4NMzmA3OjXckcUx5dakyD_TRwfj3j2_02MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANBXnMm7QCab3cU4NMzmA3OjXckcUx5dakyD_TRwfj3j2_02MA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 02:29:22PM +0530, Adil Mujeeb wrote:
> Hi,
> 
> 
> >-       PowerData = (1 << 31) | (0 << 30) | (24 << 24) |
> BitReverse(w89rf242_txvga_data[i][0], 24);
> >+       PowerData = (1 << 31) | (0 << 30) | (24 << 24)
> >+                           | BitReverse(w89rf242_txvga_data[i][0], 24);
> .....
> .....
> 
> >-       reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) |
> (DEFAULT_LONG_RETRY_LIMIT << 4) | DEFAULT_SHORT_RETRY_LIMIT;
> >+       reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) |
> >+                                      (DEFAULT_LONG_RETRY_LIMIT << 4) |
> >+                                      DEFAULT_SHORT_RETRY_LIMIT;
> 
> I think consistency is needed. Either break the lines putting the OR
> operator ( | ) at the start of new line or at the end of each line. People
> has its own preference but here you have used both style in single file.
> Just a suggestion.
> 

Put the '|' character at the end of the line.  That's the New Unwritten
Style Guidelines.  Most of the kernel does it this way and it's easier
to read.

But this could be fixed in a later patch instead of redoing the whole
series.

regards,
dan carpenter

