Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3IJO6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:58:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35780 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3IJO6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:58:21 -0400
Date: Tue, 10 Sep 2013 17:58:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130910145802.GD19256@mwanda>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
 <20130910143416.GC2270@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910143416.GC2270@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, the devel@driverdev.osuosl.org list seems to be down again.  I
still have not recieved the v3 patch.  Use the
driverdev-devel@linuxdriverproject.org email list instead.

regards,
dan carpenter

