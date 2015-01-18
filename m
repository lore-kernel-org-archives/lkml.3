Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbbARAco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:32:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbbARAcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:32:43 -0500
Date: Sat, 17 Jan 2015 16:21:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Moritz Fischer <moritz.fischer@ettus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: Fixed checkpatch.pl warning
Message-ID: <20150118002110.GA8552@kroah.com>
References: <1421080281-6889-1-git-send-email-moritz.fischer@ettus.com>
 <1421080281-6889-2-git-send-email-moritz.fischer@ettus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421080281-6889-2-git-send-email-moritz.fischer@ettus.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 05:31:21PM +0100, Moritz Fischer wrote:
> The file triggered the following warning:
> 
> WARNING: line over 80 characters
> 
> Signed-off-by: Moritz Fischer <moritz.fischer@ettus.com>
> ---
>  drivers/staging/android/sync_debug.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Someone else sent this in before you did, sorry.

greg k-h
