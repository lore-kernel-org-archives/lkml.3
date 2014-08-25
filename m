Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaHYOmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:42:45 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:40617 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490AbaHYOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:42:44 -0400
Date: Mon, 25 Aug 2014 16:42:40 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Wei.Yang@windriver.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] MIPS:KDUMP: set a right value to
 kexec_indirection_page variable
Message-ID: <20140825144240.GD25892@linux-mips.org>
References: <1406806949-27039-1-git-send-email-Wei.Yang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406806949-27039-1-git-send-email-Wei.Yang@windriver.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 07:42:29PM +0800, Wei.Yang@windriver.com wrote:

> From: Yang Wei <Wei.Yang@windriver.com>
> 
> Since there is not indirection page in crash type, so the vaule of the head
> field of kimage structure is not equal to the address of indirection page but
> IND_DONE. so we have to set kexec_indirection_page variable to the address of
> the head field of image structure.

Applied, thanks.

Your patch applies to 3.8-stable and newer only.  If you happen to have
patches for older kernels, I'd appreciate if you post them.

Thanks,

  Ralf
