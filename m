Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaGaAVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:21:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaGaAVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:21:52 -0400
Date: Wed, 30 Jul 2014 17:21:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: devel@driverdev.osuosl.org, oort10@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:r8190: coding style: Fixed checkpatch reported
 Error
Message-ID: <20140731002124.GB6157@kroah.com>
References: <1406632313-2187-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406632313-2187-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:41:53PM +0530, Sanjeev Sharma wrote:
> This is a patch to the r8190_rtl8256.c file that fixes
> checkpatch reported space & coding style issues.
> 
> Signed-off-by: Sanjeev Sharma<Sanjeev_Sharma@mentor.com>

Please use a ' ' character...

Please resend all of your patches, they don't have signed-off-by lines,
and I don't know what order to apply them in, even if I could do so.

greg k-h
