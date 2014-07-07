Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaGGUn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:43:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGGUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:43:24 -0400
Date: Mon, 7 Jul 2014 13:47:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171
 __ioremap_caller+0x290/0x2fa()
Message-ID: <20140707204747.GA24934@kroah.com>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 10:32:56PM +0200, Fabio Coatti wrote:
> I'm seeing this message in latest kernels (this is from 3.15.4, but I have same
> message starting from 3.15.0, IIRC):

So 3.14.0 didn't show this?

If so, can you run 'git bisect' between those two kernel versions to try
to track down the issue?

thanks,

greg k-h
