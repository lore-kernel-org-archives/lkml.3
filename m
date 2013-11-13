Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab3KMGjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:39:53 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36483 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3KMGjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:39:43 -0500
Date: Tue, 12 Nov 2013 22:39:39 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lee Jones <lee.jones@linaro.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] pm2301-charger: remove unneeded NULL checks
Message-ID: <20131113063939.GA31149@teo>
References: <20131107080617.GQ21844@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131107080617.GQ21844@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 11:06:17AM +0300, Dan Carpenter wrote:
> If "pm2" were NULL we would oops printing the error message.
> Fortunately, that's not possible so I have removed the NULL checks.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks!
