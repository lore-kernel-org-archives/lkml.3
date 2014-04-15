Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaDOJtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:49:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:43389 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaDOJtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:49:49 -0400
Message-ID: <1397555363.14218.6.camel@pasglop>
Subject: Re: [PATCH 1/1] powerpc: Increase COMMAND_LINE_SIZE to 2048 from
 512.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org, anton@samba.org
Date: Tue, 15 Apr 2014 19:49:23 +1000
In-Reply-To: <534C2FEB.2000803@canonical.com>
References: <cover.1397260361.git.joseph.salisbury@canonical.com>
	 <84356b1cb9452226d54641a71e4b1363e78d4417.1397260362.git.joseph.salisbury@canonical.com>
	 <534C2FEB.2000803@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 14:58 -0400, Joseph Salisbury wrote:
> 
> After further review, it appears ppc does not actually use the define
> in
> the ppc headers but uses the common generic
> default(include/uapi/asm-generic/setup.h).  COMMAND_LINE_SIZE should
> probably become a kernel config option.  Do folks agree that is the
> correct thing to do?  If so, I can re-work the patch.

No objection on my side.

Make sure you remove any unused arch define while at it.

Cheers,
Ben.


