Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbaFZPI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:08:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaFZPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:08:57 -0400
Message-ID: <53AC3787.7090309@infradead.org>
Date: Thu, 26 Jun 2014 08:08:55 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 26 (crypto/drbg)
References: <20140626164130.4d01a3b2@canb.auug.org.au>
In-Reply-To: <20140626164130.4d01a3b2@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/14 23:41, Stephen Rothwell wrote:
> Hi all,
> 
> The powerpc allyesconfig is again broken more than usual.
> 
> Changes since 20140625:
> 


on i386:

../crypto/drbg.c:1097:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'size_t' [-Wformat]
../crypto/drbg.c:1966:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'unsigned int' [-Wformat]
../crypto/drbg.c:1966:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]


-- 
~Randy
