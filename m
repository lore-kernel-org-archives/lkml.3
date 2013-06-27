Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3F0Mug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:50:36 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:17233 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752264Ab3F0Mue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:34 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Atmel updates to atmel_mxt_ts touch controller driver - v6
Date: Thu, 27 Jun 2013 13:48:35 +0100
Message-Id: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor updates to these patches to address review comments. I've rebased
them on the latest dtor/next tree.

Input: atmel_mxt_ts - Verify Information Block checksum on probe
- Fix bug which might cause erroneous debug output due to use of krealloc (thanks to
  Yufeng Shen for spotting this)

Input: atmel_mxt_ts - Implement T63 Active Stylus support
- Add T63 to #defines since there will be other active stylus objects

Input: atmel_mxt_ts - Implement debug output for messages
Input: atmel_mxt_ts - Add memory access interface via sysfs
- remove from series (move mem_size calculation)

-- 
Nick Dyer Senior Software Engineer
ITDev Hardware and Software Development Consultancy http://www.itdev.co.uk

