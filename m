Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3JZAE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 20:04:56 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47335 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3JZAEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 20:04:54 -0400
Date: Fri, 25 Oct 2013 17:04:51 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: =?utf-8?B?77+977+977+977+977+977+9?= <kw46.nam@samsung.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] Fuel Guague: MAX17040: Use regmap to interface with
 internal registers
Message-ID: <20131026000451.GB19447@teo>
References: <002101cece3a$53eeff80$fbccfe80$%nam@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <002101cece3a$53eeff80$fbccfe80$%nam@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:48:35PM +0900, ������ wrote:
> We use regmap to interface with internal registers in fuel guague MAX17040.
> 
> Signed-off-by: Nam KwanWoo <kw46.nam@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

$ git am -s patch
fatal: cannot convert from ks_c_5601-1987 to UTF-8

I fixed this manually, but then I noticed this:

> @@ -124,22 +104,23 @@ static void max17040_get_vcell(struct i2c_client
> *client)

Which means that the patch is also line-wrap damaged... so I gave up.

Anton
