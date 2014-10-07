Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaJGMKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:10:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55519 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaJGMKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:10:20 -0400
Date: Tue, 7 Oct 2014 14:10:18 +0200
From: Pavel Machek <pavel@denx.de>
To: dinguyen@opensource.altera.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, marex@denx.de
Subject: socfpga ethernet problems with ethernet in 3.17 with
 u-boot-2013.01.01
Message-ID: <20141007121017.GA20998@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After some testing:

u-boot-2013.01.01 + linux-3.17 => ethernet does	not work
                  (unless ethernet is used in u-boot, for example
                  using ping)
u-boot-marex-20140920a + linux-3.17 => working ethernet

One of our guesses is that maybe we don't pull ethernet out of reset
in the first case?

Best regards,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
