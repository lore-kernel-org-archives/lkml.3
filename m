Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaKKFbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:31:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaKKFbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:31:18 -0500
Date: Tue, 11 Nov 2014 14:30:00 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Fabio Estevam <festevam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver needs an owner
Message-ID: <20141111053000.GA29706@kroah.com>
References: <CAOMZO5CZ0rzhBquTLp+oo0ddvwy22iz0yE3pyap+wVDT0+oMKQ@mail.gmail.com>
 <20141110234555.GB21278@kroah.com>
 <20141110235204.GA2914@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110235204.GA2914@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:52:05AM +0100, Wolfram Sang wrote:
> > Oops, we forgot that for drivers built into the kernel, THIS_MODULE is
> > NULL :(
> > 
> > Wolfram, want me to revert this patch?
> 
> Yes, I sent out the revert a second ago, too. Still wondering why this
> did not trigger here... I'll have a look.

Now applied, thanks.

greg k-h
