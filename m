Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3KSSku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:40:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KSSkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:40:49 -0500
Date: Tue, 19 Nov 2013 10:41:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 0/9] staging/lustre: sync with exernal tree
Message-ID: <20131119184111.GA19389@kroah.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 09:23:39PM +0800, Peng Tao wrote:
> Hi Greg,
> 
> Following patches were ported from Lustre external tree.
> 
> PATCH 4/9 was splitted into five patches to do separate things that
> were done in the original single patch.
> 
> PATCh 3/9 is a cleanup patch.

I've applied some of these, the ones I have not, I have commented on
why.

greg k-h
