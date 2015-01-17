Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbbAQXZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:25:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbbAQXZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:25:38 -0500
Date: Sat, 17 Jan 2015 14:33:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] Staging: comedi: patch to fix line over 80 characters
 warning
Message-ID: <20150117223312.GA15083@kroah.com>
References: <1420865403-4932-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420865403-4932-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 10:20:03AM +0530, jitendra kumar khasdev wrote:
> This is patch to pcl812.c that fix line over 80 characters warning
> which is found by checkpatch.pl tool. Reduce the extra space around
> equal sign that fix warning.
> 
> Signed-off-by: Jitendra kumar khasdev <jkhasdev@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcl812.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Does not apply to my tree :(
