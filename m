Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaEaUDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:03:48 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:53312 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbaEaUDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:03:47 -0400
Message-ID: <538A35A0.1080006@gmail.com>
Date: Sat, 31 May 2014 23:03:44 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: swetland@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: binder.c: Use more appropriate functions
 for euid retrieval
References: <538A30E6.6010403@gmail.com> <20140531195205.GA14077@kroah.com>
In-Reply-To: <20140531195205.GA14077@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014.05.31. 22:52, Greg KH wrote:
> What kernel tree did you make this against?  It doesn't seem to match up
> with what is in my staging-next branch to merge with Linus for the next
> release, so please work against that one.

Made against staging-next branch of your linux-next staging tree.

> Oh, and I think this is already been done, although in a bit different
> way there, please check to make sure it is correct.

Yes, I have noticed the changes after I have made the patch but I
thought mine are a bit cleaner so I have rebased the patch against the
changes that are already applied.
