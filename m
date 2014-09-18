Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaIRL4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:56:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39899 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaIRL4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:56:10 -0400
Date: Thu, 18 Sep 2014 13:56:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org
Subject: Re: [PATCH 2/2] power: smb347-charger: Support Summit SMB358 charger
 IC.
Message-ID: <20140918115607.GA7377@amd>
References: <1410922044-4170-1-git-send-email-jonghwa3.lee@samsung.com>
 <1410922044-4170-3-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410922044-4170-3-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-09-17 11:47:24, Jonghwa Lee wrote:
> Summit microelectronics' SMB358 charger chip has almost same register map
> and functionality with SMB347. The voltage and current table are only differed.
> Thus, SMB347 driver can support SMB358 chip fully with few modifications.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by : Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by : Myungjoo Ham <myungjoo.ham@samsung.com>

Acked-by: Pavel Machek <pavel@ucw.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
