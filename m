Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaD0Wgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:36:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaD0Wgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:36:43 -0400
Date: Sun, 27 Apr 2014 15:37:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/5] Lustre Klocwork fixes
Message-ID: <20140427223728.GA1563@kroah.com>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 05:17:21PM -0400, Oleg Drokin wrote:
> This is just splitting big lnet fixes patch from Klocwork static
> analysis tool into smaller bits.
> 
> Dmitry Eremin (5):
>   staging/lustre/lnet: fix potential null pointer dereference
>   staging/lustre/lnet: remove unused variable
>   staging/lustre/lnet: fix potential null pointer dereference
>   staging/lustre/lnet: fix potential null pointer dereference
>   staging/lustre/lnet: fix potential null pointer dereference

You can't send the same subject: for all patches, that's not good.
Please be more specific.

greg k-h
