Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3IRNK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:10:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55264 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3IRNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:10:56 -0400
Date: Wed, 18 Sep 2013 15:10:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uio: Simplify uio error path by using devres functions
Message-ID: <20130918131055.GA2764@amd.pavel.ucw.cz>
References: <c0afb787f4d36e0f4cfb055ce8c566acbe39beca.1378964390.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0afb787f4d36e0f4cfb055ce8c566acbe39beca.1378964390.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-09-12 07:39:59, Michal Simek wrote:
> Using devres functions simplify driver error path.
> - Use devm_kzalloc
> - Use devm_request_irq
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
