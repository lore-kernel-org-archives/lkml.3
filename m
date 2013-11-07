Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3KGIOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:14:07 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35255 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3KGIN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:13:56 -0500
Date: Thu, 7 Nov 2013 00:13:52 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: remove deprecated IRQF_DISABLED
Message-ID: <20131107081352.GG3805@norris.computersforpeace.net>
References: <1381645292-9499-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381645292-9499-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 08:21:32AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Pushed to l2-mtd.git. Thanks!

Brian
