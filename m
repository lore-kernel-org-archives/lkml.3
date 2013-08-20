Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3HTE1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:27:31 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43754 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3HTE1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:27:30 -0400
Date: Mon, 19 Aug 2013 21:27:26 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 4/4] mtd: m25p80: remove unnecessary ifdef
Message-ID: <20130820042726.GF28421@norris.computersforpeace.net>
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
 <1376302946-11534-5-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376302946-11534-5-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 12:22:26PM +0200, Sascha Hauer wrote:
> of_property_read_bool properly compiles away, no need to ifdef this
> for non DT builds.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Pushed only this one to l2-mtd.git, since it's independent.

Thanks,
Brian
