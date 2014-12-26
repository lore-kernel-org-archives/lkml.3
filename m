Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbaLZVnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 16:43:42 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65142 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLZVnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 16:43:39 -0500
Date: Fri, 26 Dec 2014 16:43:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:ata: Remove unneeded fix me comment for the
 function,mv_print_info in sata_mv.c
Message-ID: <20141226214335.GB10889@htj.dyndns.org>
References: <1419629997-2623-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419629997-2623-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 04:39:57PM -0500, Nicholas Krause wrote:
> Removes a unneed fix me comment for the function,mv_print_info in sata_mv.c.
> This comment is no longer needed as this function has been completed correctly
> to print out hardware info to the kernel log buffer and therefore this comment
> is no longer needed for the function,mv_print_info.

How do we know the function is completed correctly?

Thanks.

-- 
tejun
