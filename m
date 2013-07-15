Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab3GOR1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:27:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3GOR1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:27:08 -0400
Message-ID: <51E430E0.9050304@canonical.com>
Date: Mon, 15 Jul 2013 13:26:56 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: adlr@chromium.org, nlopezcasad@logitech.com
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Regression][v3.10][v3.11] Revert "HID: Fix logitech-dj: missing
 Unifying device issue"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

A bug was opened against the Ubuntu kernel[0].  It was found that
reverting the following commit resolved this bug:

commit 8af6c08830b1ae114d1a8b548b1f8b056e068887
Author: Andrew de los Reyes <adlr@chromium.org>
Date:   Mon Feb 18 09:20:23 2013 -0800

    Revert "HID: Fix logitech-dj: missing Unifying device issue"


The regression was introduced as of v3.10-rc1.  Commit 8af6c08 reverts
commit 5962640, so it seems commit 5962640 may still be needed.

I see that you are the author of this patch, so I wanted to run this by
you.  I was thinking of requesting a revert for v3.11, but I wanted to
get your feedback first.


Thanks,

Joe

[0] http://pad.lv/1194649
