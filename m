Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3H1Bch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:32:37 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37356 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3H1Bcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:32:35 -0400
Date: Tue, 27 Aug 2013 18:27:52 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH] power: rx51_battery: Replace hardcoded channels values.
Message-ID: <20130828012752.GD10506@lizard>
References: <1377125110-16886-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1377125110-16886-1-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 12:45:10AM +0200, Marek Belisko wrote:
> In twl4030_madc header exist defines for fixed channels
> + add rx51 specific channels and replace all hardcoded channels
> values.
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>

Applied, thanks!

Anton
