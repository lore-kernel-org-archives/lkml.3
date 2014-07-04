Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbaGDWMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:12:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaGDWMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:12:22 -0400
Date: Fri, 4 Jul 2014 15:12:05 -0700
From: gregkh <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Qualcomm "All Rights Reserved" in Linux staging
Message-ID: <20140704221205.GA32013@kroah.com>
References: <1983136768.8892.1404508828693.JavaMail.zimbra@efficios.com>
 <1404511548.18844.3.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404511548.18844.3.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 12:05:48AM +0200, Paul Bolle wrote:
> On Fri, 2014-07-04 at 21:20 +0000, Mathieu Desnoyers wrote:
> > grep -r "Qualcomm" . |grep -i "rights"
> > ./drivers/staging/ft1000/ft1000-usb/ft1000_usb.c: * CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
> > ./drivers/staging/ft1000/ft1000-usb/ft1000_download.c:* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
> > ./drivers/staging/ft1000/ft1000-usb/ft1000_hw.c:/* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
> 
> That's actually a common pattern:
>     $ git grep -i "Copyright.*All Rights Reserved" v3.16-rc3 | wc -l
>     5203

Yeah, I used to be "worried" about that as well, turns out it means
nothing :)

It's the license of the code that is the issue, not the copyright line,
which all lawyers tell me now shouldn't even be in a file, as it, again,
means nothing.

thanks,

greg k-h
