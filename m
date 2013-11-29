Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab3K2Mtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:49:51 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38238 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab3K2Mto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:49:44 -0500
Date: Fri, 29 Nov 2013 12:49:41 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Roland <devzero@web.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kernel-team@lists.ubuntu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] - add "fixpae" bootparam to fix/workaround #930447
Message-ID: <20131129124941.GA18950@bark>
References: <trinity-1045dd8c-e43f-4f8c-94e4-c0f0f15f611d-1385507362267@3capp-webde-bs36>
 <52952FD9.1060906@zytor.com>
 <4EE8EA759E2646FFB2FC72F10ED743AC@samsungnetbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE8EA759E2646FFB2FC72F10ED743AC@samsungnetbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 09:41:03PM +0100, Roland wrote:
> This patch is meant primarly for ubuntu, as they only ship PAE
> enabled kernels and don`t ship non-PAE kernels anymore.  So this
> resolves an ubuntu specific problem (as the installer disc also has
> PAE enabled kernel).
> 
> I know it`s not perfect, but poking cpu bits in arrays is above my
> skills and i have already spent really much time with this trying to
> resolve a problem for the end-user intruduced by nothing but the
> decision to discontinue Non-PAE kernels.

I think the complaints are more about how it works that the intent.
Kernel engineers are by their very nature very risk averse, so it would
indeed be good to set the bit correctly in the cpu capability flags, and
to do that based on the machine type.

I might just have a machine which exhibits this behaviour, I will try
and look it out and see if we can morph this into something appropriate.

-apw
