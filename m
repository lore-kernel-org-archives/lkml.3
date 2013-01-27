Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3A0QX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 11:23:58 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:51812 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3A0QX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 11:23:56 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 27 Jan 2013 17:23:55 +0100
Message-ID: <CA+icZUWH2mGF+HrkHFxkTr_kc4Zc1xtO-9y0NqT2Ps++c7XdNQ@mail.gmail.com>
Subject: Re: Boot crashes due to global async pending list
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have hit the same problem on pm/suspend.

The fix is pending in wq.git#for-next:

commit a0327ff0eda915be623658babacef706099c11a8
"async: initialise list heads to fix crash"

Hope this helps you!

Regards,
- Sedat -

http://marc.info/?l=linux-kernel&m=135929291904642&w=2
http://marc.info/?t=135919870600001&r=1&w=2
