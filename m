Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbaFTATc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:19:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaFTATb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:19:31 -0400
Date: Thu, 19 Jun 2014 17:23:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Belur <askb23@gmail.com>
Cc: andreas.dilger@intel.com, oleg.drokin@intel.com,
        linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org
Subject: Re: [PATCH 1/3] staging: lustre: ldlm: ldlm_resource.c removed
 unecessary braces
Message-ID: <20140620002331.GA5388@kroah.com>
References: <1403193708-22407-1-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403193708-22407-1-git-send-email-askb23@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:01:46AM +1000, Anil Belur wrote:
> From: Anil Belur <askb23@gmail.com>
> 
> - this fixed the "WARNING: braces {} are not necessary for
>   single statement blocks"
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
>  drivers/staging/lustre/lustre/ldlm/ldlm_resource.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Doesn't apply :(
