Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaHYMFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:05:04 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:39338 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaHYMFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:05:01 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2014 08:05:01 EDT
Date: Mon, 25 Aug 2014 13:27:54 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] MIPS: BCM63xx: delete double assignment
Message-ID: <20140825112754.GE27724@linux-mips.org>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
 <1408818808-18850-5-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408818808-18850-5-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 08:33:25PM +0200, Julia Lawall wrote:

> Delete successive assignments to the same location.  In each case, the
> duplicated assignment is modified to be in line with other nearby code.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Looking good, applied.

Thanks,

  Ralf
