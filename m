Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3ATVBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 16:01:37 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53468 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3ATVBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 16:01:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130120163130.GA7730@elgon.mountain>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B7118@saturn3.aculab.com>
	<20130120163130.GA7730@elgon.mountain>
Date: Sun, 20 Jan 2013 22:01:33 +0100
Message-ID: <CACna6ryF=3y8cNxLSnpbWbuQjAp3PZO5k2BxOGFC9H7d+aXz8A@mail.gmail.com>
Subject: Re: [patch v3] b43: N-PHY: fix gain in b43_nphy_get_gain_ctl_workaround_ent()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/20 Dan Carpenter <dan.carpenter@oracle.com>:
> There were no break statements in this switch statement so everything
> used the default settings.  Per Walter Harms's suggestion, I've replaced
> the switch statement and done a little cleanup.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Make additional style fixes as well while we're messing with the
>     function.
> v3: Make the array static const int.

Looks fine, thanks Dan

-- 
Rafał
