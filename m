Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaKPIiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 03:38:00 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49732 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaKPIh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 03:37:58 -0500
Date: Sun, 16 Nov 2014 09:37:56 +0100
From: Pavel Machek <pavel@denx.de>
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Torokhov <dtor@chromium.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HIS: nokia-modem: fix error handling of
 irq_of_parse_and_map
Message-ID: <20141116083756.GA30646@amd>
References: <20141114220637.GA33546@dtor-ws>
 <20141114224407.GB18566@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114224407.GB18566@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:44:07, Sebastian Reichel wrote:
> On Fri, Nov 14, 2014 at 02:06:37PM -0800, Dmitry Torokhov wrote:
> > Return value of irq_of_parse_and_map() is unsigned int, with 0
> > indicating failure, so testing for negative result never works.
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> 
> https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=for-next&id=d95dc9e388104488d0f5a5969c435e601840da2e
> 

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
