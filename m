Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3APNgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:36:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3APNgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:36:08 -0500
Date: Wed, 16 Jan 2013 16:36:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Volokh Konstantin <volokh84@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        mchehab@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        rdunlap@xenotime.net, hans.verkuil@cisco.com, justinmattock@gmail.com
Subject: Re: [PATCH 3/4] staging: media: go7007: i2c GPIO initialization
 Reset i2c stuff for GO7007_BOARDID_ADLINK_MPG24 need reset GPIO always when
 encoder initialize
Message-ID: <20130116133608.GH4584@mwanda>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
 <1358341251-10087-3-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358341251-10087-3-git-send-email-volokh84@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You've added the writes for GO7007_BOARDID_ADLINK_MPG24 but removed
them for GO7007_BOARDID_XMEN and GO7007_BOARDID_XMEN_III.  Won't
that break those boards?

regards,
dan carpenter


