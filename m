Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab3LJHNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:13:34 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33166 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3LJHNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:13:33 -0500
Date: Mon, 9 Dec 2013 23:13:24 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 19/39] mtd: denali: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131210071324.GA11489@norris.computersforpeace.net>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <002801ceefb4$cef24a20$6cd6de60$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002801ceefb4$cef24a20$6cd6de60$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 08:18:28AM +0900, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Pushed to l2-mtd.git.

Brian
