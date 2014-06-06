Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaFFXc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:32:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47000 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbaFFXc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:32:28 -0400
X-Sasl-enc: fi3W2lnNg4QG5io4wpDzo0nMbjuNx32qAN2rHp+ulfgL 1402097543
Date: Fri, 6 Jun 2014 16:32:15 -0700
From: GregKH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Thomas Wood <tommyandrena@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/w1/w1_int.c: Fix style errors.
Message-ID: <20140606233215.GA1281@kroah.com>
References: <1401491420-6953-1-git-send-email-tommyandrena@gmail.com>
 <2069611401539121@web10m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2069611401539121@web10m.yandex.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 04:25:21PM +0400, Evgeniy Polyakov wrote:
> Hi Thomas
> 
> 31.05.2014, 03:11, "Thomas Wood" <tommyandrena@gmail.com>:
> > Replace spaces at beginning of the string with tabs, and replace foo * bar with foo *bar in a pointer declaration.
> >
> > Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
> 
> Looks good, thank you.
> Greg, please pull it into your tree or suggest appropriate.
> 
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Thanks, I'll take this after 3.16-rc1 is out.

greg k-h
