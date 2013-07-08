Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3GHHkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:40:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:43949 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab3GHHkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:40:32 -0400
Message-ID: <1373269221.4446.32.camel@pasglop>
Subject: Re: [PATCH v2] powerpc: add real mode support for dma operations on
 powernv
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Jul 2013 17:40:21 +1000
In-Reply-To: <51DA6AE6.9040201@ozlabs.ru>
References: <1373123227-22969-6-git-send-email-aik@ozlabs.ru>
	 <1373258669-3130-1-git-send-email-aik@ozlabs.ru>
	 <1373268055.4446.31.camel@pasglop> <51DA6AE6.9040201@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 17:31 +1000, Alexey Kardashevskiy wrote:

> btw is phys_addr_t correct here?

Yes.

Cheers,
Ben.


