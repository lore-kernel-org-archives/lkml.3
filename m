Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaJKUSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 16:18:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaJKUSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 16:18:24 -0400
Date: Sat, 11 Oct 2014 13:17:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: add helper function to create device related
 seq_file
Message-ID: <20141011201723.GA29439@kroah.com>
References: <1413043315-22332-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413043315-22332-1-git-send-email-arend@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 06:01:55PM +0200, Arend van Spriel wrote:
> This patch adds a helper function that simplifies adding a
> sequence file for device drivers. The calling device driver
> needs to provide a read function and a device pointer. The
> field struct seq_file::private will reference the device
> pointer upon call to the read function so the driver can
> obtain his data from it and do its seq_printf() calls.
> 
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  fs/debugfs/file.c       | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/debugfs.h | 16 ++++++++++++++-
>  2 files changed, 69 insertions(+), 1 deletion(-)

Do you have some kernel code pending that needs this change?  Or can
existing users be moved to it, saving them code?
