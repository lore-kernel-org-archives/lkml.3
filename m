Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3CSAoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:44:11 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62775 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3CSAoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:44:10 -0400
Date: Mon, 18 Mar 2013 17:40:13 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH v5 1/3] gpio: gpio-generic: Add 16 and 32 bit big endian
 byte order support
Message-ID: <20130319004012.GA1004@lizard.gateway.2wire.net>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
 <1363355140-28216-2-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363355140-28216-2-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 02:45:38PM +0100, Andreas Larsson wrote:
> There is no general support for 64-bit big endian accesses, so that is
> left unsupported.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

This looks perfect, thanks a lot!

Acked-by: Anton Vorontsov <anton@enomsg.org>
