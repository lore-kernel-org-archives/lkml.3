Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaAOU6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:58:17 -0500
Received: from forward15.mail.yandex.net ([95.108.130.119]:53774 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaAOU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:58:07 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GregKH <greg@kroah.com>
In-Reply-To: <20140115045200.GA29560@spacedout.fries.net>
References: <1388299556-12669-1-git-send-email-David@Fries.net> <20140115045200.GA29560@spacedout.fries.net>
Subject: Re: [PATCH 16/16] hold bus_mutex in netlink and search
MIME-Version: 1.0
Message-Id: <8351389819482@web5j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 16 Jan 2014 00:58:02 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

15.01.2014, 08:52, "David Fries" <David@Fries.net>:
> The bus_mutex needs to be taken to serialize access to a specific bus.
> netlink wasn't updated when bus_mutex was added and was calling
> without that lock held, and not all of the masters were holding the
> bus_mutex in a search. šThis was causing the ds2490 hardware to stop
> responding when both netlink and /sys slaves were executing bus
> commands at the same time.
>
> Signed-off-by: David Fries <David@Fries.net>

Looks good to me, thank you.
Greg, please pull the whole set if you hadn't yet

Acked-by: Evgeniy Polyakov <zbr@ioremap.net> 
