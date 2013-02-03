Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3BCDsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:48:36 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:43233 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3BCDsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:48:35 -0500
Date: Sat, 2 Feb 2013 19:44:51 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq27x00_battery: Fix reporting battery temperature
Message-ID: <20130203034451.GH25016@lizard.sbx00618.mountca.wayport.net>
References: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 11:06:09AM +0100, Pali Rohár wrote:
> Reported temperature can be also negative, so cache value in non negative Kelvin degree.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---

Applied, thanks!
