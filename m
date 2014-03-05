Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaCES26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:28:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaCES25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:28:57 -0500
Date: Wed, 5 Mar 2014 10:30:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] kernfs: fix off by one error.
Message-ID: <20140305183042.GC9824@kroah.com>
References: <74f5a436ebf5c13ed89a81c47ba09a6549e385f6.1394035568.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74f5a436ebf5c13ed89a81c47ba09a6549e385f6.1394035568.git.richardcochran@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 05:10:52PM +0100, Richard Cochran wrote:
> The hash values 0 and 1 are reserved for magic directory entries, but
> the code only prevents names hashing to 0. This patch fixes the test
> to also prevent hash value 1.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/kernfs/dir.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Is this for 3.14-final or 3.15-rc1?

thanks,

greg k-h
