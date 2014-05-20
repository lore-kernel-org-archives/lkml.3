Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaETLlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:41:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20155 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaETLlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:41:44 -0400
Date: Tue, 20 May 2014 14:41:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>, devel@driverdev.osuosl.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/8] staging: r8712u: Remove useless return variables
Message-ID: <20140520114113.GG15585@mwanda>
References: <1400582028-24990-1-git-send-email-peter.senna@gmail.com>
 <537B38FF.4050106@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537B38FF.4050106@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those concerns are valid but the code was like that in the original so
we should merge this patch as is and hope some volunteer will fix things
up in a follow on patch.

Fixing them in this patch would be a mistake anyway because of the one
thing per patch rule.

regards,
dan carpenter
