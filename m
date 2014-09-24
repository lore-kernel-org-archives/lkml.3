Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaIXISl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:18:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaIXISh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:18:37 -0400
Date: Tue, 23 Sep 2014 23:41:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sorin Facaoaru <work@sorin.cc>
Cc: john.stultz@linaro.org, rebecca@android.com, ccross@android.com,
        mitchelh@codeaurora.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: ion: Add blank line after variable
 declaration
Message-ID: <20140924064120.GB15680@kroah.com>
References: <1411452892-4786-1-git-send-email-work@sorin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411452892-4786-1-git-send-email-work@sorin.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:14:52PM -0700, Sorin Facaoaru wrote:
> This patch fixes the checkpatch.pl warning:
> 
> WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Sorin Facaoaru <work@sorin.cc> 
> ---
>  drivers/staging/android/ion/ion.c | 1 +
>  1 file changed, 1 insertion(+)

Someone else already sent in this change, sorry.

greg k-h
