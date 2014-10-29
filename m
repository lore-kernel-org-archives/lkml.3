Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122AbaJ2PmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:42:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40310 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934090AbaJ2PmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:01 -0400
X-Sasl-enc: ub6CVhi2WZVbjPYtJgeAKB+SEglBuOP7MApygge0nqzT 1414597320
Date: Wed, 29 Oct 2014 16:42:40 +0800
From: Greg KH <greg@kroah.com>
To: Akshay Sarode <akshaysarode21@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Octeon: Staging Driver: Remove coding warnings
Message-ID: <20141029084240.GA12496@kroah.com>
References: <1413099831-5127-1-git-send-email-akshaysarode21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413099831-5127-1-git-send-email-akshaysarode21@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 01:13:51PM +0530, Akshay Sarode wrote:
> Checkpatch coding warnings of 'Missing a blank line after declaration'
> 
> Signed-off-by: Akshay Sarode <akshaysarode21@gmail.com>
> ---
>  drivers/staging/octeon/ethernet-tx.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Someone else already did this, sorry :(
