Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162836Ab3DEWCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:02:00 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:65104 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162757Ab3DEWB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:01:58 -0400
Date: Fri, 5 Apr 2013 15:01:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: arve@android.com, Dan Carpenter <dan.carpenter@oracle.com>,
        viro@zeniv.linux.org.uk, mirsal@mirsal.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android: looping issue, need break when get
 value firstly.
Message-ID: <20130405220156.GC31680@kroah.com>
References: <515E85C5.7010706@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515E85C5.7010706@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 04:05:25PM +0800, Chen Gang wrote:
> 
>   need break when 'target_thread' get value, firstly.
> 
>     'tmp' is a stack (thread->transaction_stack),
>     if 'proc' was the same between child node and parent node,
>     the child would have higher priority than parent.

Are you sure about this?

have you tested it?

greg k-h
