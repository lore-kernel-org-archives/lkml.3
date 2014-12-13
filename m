Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaLMTH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 14:07:29 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:41316 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaLMTH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 14:07:28 -0500
Date: Sat, 13 Dec 2014 19:07:05 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Loic Pefferkorn <loic@loicp.eu>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com, jun.j.tian@intel.com,
        octavian.purdila@intel.com, nnk@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: goldfish: Fix minor coding style
Message-ID: <20141213190705.0faaf119@lxorguk.ukuu.org.uk>
In-Reply-To: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2014 17:29:26 +0100
Loic Pefferkorn <loic@loicp.eu> wrote:

> Hello,
> 
> The convention for checking for NULL pointers is !ptr and not ptr == NULL.
> This patch fixes such occurences in goldfish driver, it applies against next-20141212
> 
> 
> Signed-off-by: Loic Pefferkorn <loic@loicp.eu>

Pointless churn. It makes it less readable if anything, and it removes
the type safety as you are now checking against 0 not (void *)0

NAK

Alan
