Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031314Ab3HIWJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:09:46 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63016 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031243Ab3HIWJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:09:45 -0400
Date: Fri, 9 Aug 2013 15:04:52 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Message-ID: <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 05:19:27PM +0900, Jingoo Han wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly.

Um.. what is the benefit or rationale of this patch?

Thanks,

Anton
