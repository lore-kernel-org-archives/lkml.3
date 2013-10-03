Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3JCS17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:27:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12363 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754291Ab3JCS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:27:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18N3LhBO8t3GJdii3AWjOj/
Date: Thu, 3 Oct 2013 11:27:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] ARM: omap1: fix incorrect placement of __initdata tag
Message-ID: <20131003182754.GU8949@atomide.com>
References: <1861324.5ZgdrbcBQI@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1861324.5ZgdrbcBQI@amdc1032>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> [130930 06:13]:
> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.

Thanks applying into omap-for-v3.13/fixes-not-urgent.

Tony
