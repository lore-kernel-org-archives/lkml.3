Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704Ab3DCBya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:54:30 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:37056 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759439Ab3DCBy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:54:29 -0400
Date: Wed, 3 Apr 2013 09:53:47 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-kernel@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v3] hw_random: Add Broadcom BCM2835 RNG driver
Message-ID: <20130403015347.GE20205@gondor.apana.org.au>
References: <1364135980-27750-1-git-send-email-lkundrak@v3.sk>
 <1364451578-5331-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364451578-5331-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 07:19:38AM +0100, Lubomir Rintel wrote:
> This adds a driver for random number generator present on Broadcom BCM2835 SoC,
> used in Raspberry Pi and Roku 2 devices.

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
