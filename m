Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaGKPhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:37:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30914 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaGKPhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:37:38 -0400
Date: Fri, 11 Jul 2014 18:37:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH 9/9] staging: dgap: removes redundant null check and
 change paramter for dgap_tty_digisetcustombaud()
Message-ID: <20140711153717.GT23001@mwanda>
References: <20140711102434.GA22355@devel.8.8.4.4>
 <20140711132020.GZ25880@mwanda>
 <CAHb8M2CKbbhZ51_iorB7TLxb9JgEmVze1PQ_-WzpU4_uT2EsiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2CKbbhZ51_iorB7TLxb9JgEmVze1PQ_-WzpU4_uT2EsiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 12:23:16AM +0900, DaeSeok Youn wrote:
> Can I modify the MAINTAINERS file for adding myself?

Yes.  Just send a patch to add yourself.

git log -p MAINTAINERS

regards,
dan carpenter

