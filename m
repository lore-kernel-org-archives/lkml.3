Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3KUPmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:42:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab3KUPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:42:50 -0500
Date: Thu, 21 Nov 2013 07:43:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH-v2 0/3] staging/lustre: sync with external tree
Message-ID: <20131121154319.GA6710@kroah.com>
References: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 10:24:47PM +0800, Peng Tao wrote:
> Hi Greg,
> 
> The first two patches were updated to fix checkpatch warnings.
> The third patch is unchanged as I cannot reproduce the build warning even
> with the specific gcc version. I am resending it in the hope that you can
> point out what warning it was if it is stil there.

Odd, I don't see the warning this time anymore, I don't know what was
up, perhaps an interaction from not having the previous 2 patches
applied?

Anyway, all three now applied, thanks.

greg k-h
