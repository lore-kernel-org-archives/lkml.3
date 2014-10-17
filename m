Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaJQJ00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:26:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44196 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaJQJ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:26:24 -0400
Date: Fri, 17 Oct 2014 12:26:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-api@vger.kernel.org, Anup Patel <anup.patel@linaro.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141017092601.GH23154@mwanda>
References: <20141016124741.GA3832@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016124741.GA3832@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code isn't very beautiful and there are lots of details wrong like
the error codes.

Al had some critical things to say about it but it looks like most of
those issues have been fixed.

regards,
dan carpenter

