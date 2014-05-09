Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaEIIWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:22:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43261 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaEIIWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:22:00 -0400
Date: Fri, 9 May 2014 10:21:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: use dev_err() instead of printk()
Message-ID: <20140509082131.GA21616@Nokia-N900>
References: <1399549113-19758-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399549113-19758-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-05-08 13:38:33, Martin Kepplinger wrote:
> For obvious error messages, use dev_err() in order to provide userspace
> with more useful information and use the common kernel coding style.
> 

Acked-by: Pavel Machek <pavel@ucw.cz>

