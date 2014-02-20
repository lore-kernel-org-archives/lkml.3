Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaBTXpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:45:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaBTXpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:45:35 -0500
Date: Thu, 20 Feb 2014 15:47:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Message-ID: <20140220234702.GA28682@kroah.com>
References: <1392939912-7446-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392939912-7446-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 03:45:12PM -0800, K. Y. Srinivasan wrote:
> Fix a bug in the resource walking code.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/vmbus_drv.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Fails to apply to my char-misc-next branch (if you want it in
3.14-final, that's where it belongs...):
	checking file drivers/hv/vmbus_drv.c
	Hunk #1 FAILED at 899.
	1 out of 1 hunk FAILED

