Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaKEVFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:05:06 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47173 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKEVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:05:03 -0500
Date: Wed, 5 Nov 2014 13:04:59 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Rafal Milecki <zajec5@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH v2] mtd: spi-nor: Add support for Fujitsu MB85RS1MT FRAM
Message-ID: <20141105210459.GT23619@ld-irv-0074>
References: <1414573847-15897-1-git-send-email-lisovy@merica.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414573847-15897-1-git-send-email-lisovy@merica.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:10:47AM +0100, Rostislav Lisovy wrote:
> Tested with this particular FRAM chip
> 
> Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
> Acked-by: Marek Vasut <marex@denx.de>
> ---
> Changes since v1:
> * Rebased to the newest linux-next

Pushed to l2-mtd.git.

Brian
