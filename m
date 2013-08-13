Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3HMHbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:31:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3HMHbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:31:38 -0400
Date: Tue, 13 Aug 2013 00:33:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG REPORT - IDR wraps around at 30-bits - works very bad with
 NFSD/SCTP
Message-ID: <20130813073304.GA15495@kroah.com>
References: <9a92eee58fefc1b8e3b4771ecf210d29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a92eee58fefc1b8e3b4771ecf210d29@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:31:29PM +0530, Shyam Kaushik wrote:
>         pr_info("%d\n", MAX_INT);

How did this line build, there is no MAX_INT in the kernel tree.

odd.

greg k-h
