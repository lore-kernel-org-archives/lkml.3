Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935137AbaGRRlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:41:04 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41708 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaGRRlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <53C956D5.50809@bfs.de>
References: <1405697692-23816-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<53C956D5.50809@bfs.de>
Date: Fri, 18 Jul 2014 20:41:01 +0300
Message-ID: <CANZNk80qTb0QMcpn7oBAbpO88rCCKHCCTVtmpHfzaZQun6m6Xg@mail.gmail.com>
Subject: Re: [PATCH 4/5] kernel/debug/kdb/kdb_bp.c: drop negativity check on
 unsigned value
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: wharms@bfs.de
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        dcb314@hotmail.com, jason.wessel@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-18 20:18 GMT+03:00 walter harms <wharms@bfs.de>:
> i would expect a ckeck for the upper limit with ARRAY_SIZE

Thanks, resubmitted.

-- 
Andrey Utkin
