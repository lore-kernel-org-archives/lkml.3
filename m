Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3APNfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:35:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38670 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3APNfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:35:41 -0500
Date: Wed, 16 Jan 2013 16:35:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Volokh Konstantin <volokh84@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        mchehab@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        rdunlap@xenotime.net, hans.verkuil@cisco.com, justinmattock@gmail.com
Subject: Re: [PATCH 2/4] staging: media: go7007: firmware protection
 Protection for unfirmware load
Message-ID: <20130116133545.GG4584@mwanda>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
 <1358341251-10087-2-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358341251-10087-2-git-send-email-volokh84@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that the firmware was being unloaded on disconnect?

regards,
dan carpenter

