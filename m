Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065Ab3DCQqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:46:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:37551 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759561Ab3DCQqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:46:24 -0400
Subject: Re: [PATCH] sgy-cts1000: Remove __dev* attributes
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1A7562E2-E3F4-499C-AB2E-788D08234B02@gmail.com>
Date: Wed, 3 Apr 2013 11:46:11 -0500
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 7bit
Message-Id: <33D9B386-8D85-4EBA-8DA7-5A9DC5225E54@kernel.crashing.org>
References: <1A7562E2-E3F4-499C-AB2E-788D08234B02@gmail.com>
To: Ben Collins <benmcollins13@gmail.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 18, 2013, at 6:19 PM, Ben Collins wrote:

> Somehow the driver snuck in with these still in it.
> 
> Signed-off-by: Ben Collins <ben.c@servergy.com>
> ---
> arch/powerpc/platforms/85xx/sgy_cts1000.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)

applied to next

- k

