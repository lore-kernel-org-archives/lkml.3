Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaHOP1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:27:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaHOP0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:26:43 -0400
Date: Fri, 15 Aug 2014 14:45:32 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tair Rzayev <tair.rzayev@gmail.com>
Cc: arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: binder.c: rename binder_user_error()
Message-ID: <20140815064532.GA20920@kroah.com>
References: <53E7CB3D.3030403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E7CB3D.3030403@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 10:42:53PM +0300, Tair Rzayev wrote:
> Rename binder_user_error() to shorter but no less readable binder_usr_err()
> which fixes 34 "line over 80 characters" checkpatch warnings

Those are false-positives due to the fact that we should not wrap
strings and checkpatch doesn't understand this custom macro.

So don't worry about it, the code is fine as-is.

thanks,

greg k-h
