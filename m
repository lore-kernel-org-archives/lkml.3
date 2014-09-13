Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaIMI6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 04:58:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32577 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaIMI6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 04:58:40 -0400
Date: Sat, 13 Sep 2014 11:58:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Cheng-Wei Lee <lee.rhapsody@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        peter.p.waskiewicz.jr@intel.com, Joe Perches <joe@perches.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl819x_TSProc.c: Initializer entry defined
 twice
Message-ID: <20140913085832.GB6600@mwanda>
References: <CAJKoSVTOzFjq=aZwzQC01AK=DmEDSK75ax+fUL=px96hhwibAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKoSVTOzFjq=aZwzQC01AK=DmEDSK75ax+fUL=px96hhwibAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 10:10:26AM +0800, Cheng-Wei Lee wrote:
> This patch fixs the sparse warning in rtl819x_TSProc.c:
> drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:244:58: warning:
> Initializer entry defined twice
> drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:244:61:   also defined
> here
> 

This is a false positive in Sparse.  Complain to the Sparse devs
instead.

regards,
dan carpenter

