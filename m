Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaKVUSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 15:18:50 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64478 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaKVUSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 15:18:48 -0500
Date: Sat, 22 Nov 2014 12:18:45 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: eliminate banner[] variable and switch to pr_info()
Message-ID: <20141122201845.GA5902@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>, linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1416642155-31816-1-git-send-email-jmmahler@gmail.com>
 <5470BCB8.2090904@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5470BCB8.2090904@hartkopp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

On Sat, Nov 22, 2014 at 05:41:28PM +0100, Oliver Hartkopp wrote:
> On 22.11.2014 08:42, Jeremiah Mahler wrote:
> >Several CAN modules use a design pattern with a banner[] variable at the
> >top which defines a string that is used once during init to print the
> >banner.  The string is also embedded with KERN_INFO which makes it
> >printk() specific.
> >
> >Improve the code by eliminating the banner[] variable and moving the
> >string to where it is printed.  Then switch from printk(KERN_INFO to
> >pr_info() for the lines that were changed.
> >
> >Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
> 
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Next time please only post on linux-can ML which is the first address for
> CAN related stuff - as long as you don't feel it's a networking relevant
> issue.
> 
> But for almost editorial changes - which is not urgent - linux-can should be
> enough.
> 
> Thanks,
> Oliver
> 
Will do, thanks.

-- 
- Jeremiah Mahler
