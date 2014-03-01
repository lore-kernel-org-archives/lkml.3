Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaCAKHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 05:07:31 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36301 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaCAKHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 05:07:18 -0500
MIME-Version: 1.0
Date: Sat, 1 Mar 2014 15:37:17 +0530
Message-ID: <CAFB2WuVNJY0wqGwg6c0M1pgx8P1h+3=UpGHW0=bxR65LSm3Edw@mail.gmail.com>
Subject: Staging driver: drivers/staging/vt6656/
From: Monam Agarwal <monamagarwal123@gmail.com>
To: forest@alittletooquiet.net, Greg KH <gregkh@linuxfoundation.org>,
        more.andres@gmail.com, Dan Carpenter <dan.carpenter@oracle.com>,
        nandu.hgowda@gmail.com, valentina.manea.m@gmail.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a confusion regarding functions in aes_ccmp.c. It seems none of
these functions are currently being used. So Is fine if we can remove
this file or should we keep it.

Regards,
Monam Agarwal
