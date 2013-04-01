Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3DAGJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:09:47 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64400 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab3DAGJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:09:46 -0400
Date: Sun, 31 Mar 2013 23:05:48 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] twl4030_charger: use module_platform_driver_probe()
Message-ID: <20130401060547.GC25376@lizard>
References: <005a01ce1956$21f306a0$65d913e0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <005a01ce1956$21f306a0$65d913e0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 01:01:36PM +0900, Jingoo Han wrote:
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

Applied, thanks!

Anton
