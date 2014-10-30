Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbaJ3QKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:10:38 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:58682 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaJ3QKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:10:37 -0400
Date: Thu, 30 Oct 2014 17:10:28 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Isamu Mogi <isamu@leafytree.jp>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] MIPS: R3000: Fix debug output for Virtual page
 number
Message-ID: <20141030161028.GE20282@linux-mips.org>
References: <1410278429-8541-1-git-send-email-isamu@leafytree.jp>
 <1414674458-7583-1-git-send-email-isamu@leafytree.jp>
 <1414674458-7583-2-git-send-email-isamu@leafytree.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414674458-7583-2-git-send-email-isamu@leafytree.jp>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:07:36PM +0900, Isamu Mogi wrote:

> Virtual page number of R3000 in entryhi is 20 bit from MSB. But in
> dump_tlb(), the bit mask to read it from entryhi is 19 bit (0xffffe000).
> The patch fixes that to 0xfffff000.

Looks like a cut and paste issue from the R4000 code.

Will apply,

  Ralf
