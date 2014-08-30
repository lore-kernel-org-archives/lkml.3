Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaH3Ukx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:40:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3Ukw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:40:52 -0400
Date: Sat, 30 Aug 2014 13:40:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/4] staging: rtl8188eu: rtw_debug.c
Message-ID: <20140830204051.GB16168@kroah.com>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
 <1408703600-32210-1-git-send-email-cmroliv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408703600-32210-1-git-send-email-cmroliv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 11:33:20AM +0100, Miguel Oliveira wrote:
> Convert all rtw_proc_xxx references to rtw_sys_xxx

Again, your subject: is not understandable.

And what are you doing here?

> Code with 62 WARNING: line over 80 characters, I'll write another patch
> to clean the whole file.

What do you mean by this?  Why refer to a future patch in this
changelog, that doesn't help anyone.

confused,

greg k-h
