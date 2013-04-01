Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab3DAGdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:33:11 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49129 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3DAGdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:33:10 -0400
Date: Sun, 31 Mar 2013 23:29:11 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] power: 88pm860x_charger: drop kfree of
 devm_kzalloc'd data
Message-ID: <20130401062911.GC30190@lizard>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 03:30:40PM +0900, Jingoo Han wrote:
> The devm_kzalloc function allocates memory that is released
> automatically, when a driver detaches. Thus, there is no reason
> to explicitly call kfree in probe or remove functions.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

1-14 applied, thanks!

Anton
