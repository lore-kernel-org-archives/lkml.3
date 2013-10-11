Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3JKWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:16:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3JKWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:16:55 -0400
Date: Fri, 11 Oct 2013 15:16:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: tty: incorrect test of echo_buf() result for ECHO_OP_START
Message-ID: <20131011221654.GA21345@kroah.com>
References: <alpine.DEB.2.02.1310112126001.11060@Z>
 <CABPwjKd-e+Pq5OsNptn243WJ0a=qKizAsB3KATekMRTvsHab+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPwjKd-e+Pq5OsNptn243WJ0a=qKizAsB3KATekMRTvsHab+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 12:04:50AM +0200, Roel Kluin wrote:
> Adding Andrew to CC, thanks for comments & picking up my patches, BTW.

Given that Jiri and I are the tty/serial maintainers, we should be able
to handle this, give us a few days to catch up with patches sent before
yours...

thanks,

greg k-h
