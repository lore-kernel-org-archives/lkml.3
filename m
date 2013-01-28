Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3A1AWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 19:22:09 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:38213 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3A1AWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 19:22:07 -0500
Date: Mon, 28 Jan 2013 09:21:58 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/19] ARM: shmobile: fix defconfig warning on CONFIG_USB
Message-ID: <20130128002156.GB3423@verge.net.au>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359153858-31992-2-git-send-email-arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:44:00PM +0000, Arnd Bergmann wrote:
> A recent update to the marzen_defconfig introduced a
> duplicate CONFIG_USB=y line. This removes one of the
> two.
> 
> arch/arm/configs/marzen_defconfig:86:warning: override: reassigning to symbol USB


Acked-by: Simon Horman <horms+renesas@verge.net.au>
