Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaBGXaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 18:30:18 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:43895 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaBGXaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 18:30:15 -0500
Message-ID: <1391815977.1155.71.camel@haakon3.risingtidesystems.com>
Subject: Re: Linux 3.12.10
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>,
        target-devel <target-devel@vger.kernel.org>
Date: Fri, 07 Feb 2014 15:32:57 -0800
In-Reply-To: <20140206200036.GA2121@kroah.com>
References: <20140206200036.GA2121@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 12:00 -0800, Greg KH wrote:
> I'm announcing the release of the 3.12.10 kernel.
> 
> All users of the 3.12 kernel series must upgrade.
> 
> The updated 3.12.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.12.y
> and can be browsed at the normal kernel.org git web browser:
> 	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 

Ditto for v3.12.y missing the following two upstream patches:

commit 6f6b5d1ec56acdeab0503d2b823f6f88a0af493e
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Sun Jan 19 08:26:37 2014 +0000

    percpu_ida: Make percpu_ida_alloc + callers accept task state bitmask

commit 555b270e25b0279b98083518a85f4b1da144a181
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Mon Jan 20 03:36:24 2014 +0000

    iscsi-target: Fix connection reset hang with percpu_ida_alloc

The two patches have been respun for v3.12.y code here:

http://www.spinics.net/lists/target-devel/msg06193.html
http://www.spinics.net/lists/target-devel/msg06194.html

Please apply for v3.12.y ASAP.

Thank you,

--nab

