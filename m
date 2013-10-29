Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3J2XfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:35:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41542 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751645Ab3J2XfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:35:23 -0400
Date: Wed, 30 Oct 2013 00:35:21 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mvneta: remove double validation of mac address
Message-ID: <20131030003521.6ada83a5@skate>
In-Reply-To: <1383081906-12342-1-git-send-email-laurent.navet@gmail.com>
References: <1383081906-12342-1-git-send-email-laurent.navet@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Laurent Navet,

On Tue, 29 Oct 2013 22:25:06 +0100, Laurent Navet wrote:
> Mac address validity is already checked in of_get_mac_address().
> No need to do it twice.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Thanks, but an identical patch has been posted by Luka Perkov
<luka@openwrt.org> just a few days ago. See
http://www.spinics.net/lists/netdev/msg255454.html.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
