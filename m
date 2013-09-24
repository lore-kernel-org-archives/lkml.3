Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3IXMcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:32:25 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35744 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3IXMcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:32:23 -0400
Date: Tue, 24 Sep 2013 14:32:12 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: David Daney <david.daney@cavium.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: edac: octeon: fix lack of opstate_init
Message-ID: <20130924123212.GD21257@linux-mips.org>
References: <1379717202-26990-1-git-send-email-dwalker@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379717202-26990-1-git-send-email-dwalker@fifo99.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 03:46:40PM -0700, Daniel Walker wrote:

> If the opstate_init() isn't called the driver won't start properly.
> 
> I just added it in what appears to be an appropriate place.
> 
> Signed-off-by: Daniel Walker <dwalker@fifo99.com>

Makes sense.  Unfortunately :-)

Acked-by: Ralf Baechle <ralf@linux-mips.org>

EDAC folks - I can funnel this patch through my tree or leave that to you,
whatever you prefer.  Same for Daniel's other patch.

  Ralf
