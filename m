Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab3BVSId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:08:33 -0500
Received: from [89.21.227.133] ([89.21.227.133]:5600 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755192Ab3BVSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:30 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Atmel updates to atmel_mxt_ts touch controller driver
Date: Fri, 22 Feb 2013 17:57:47 +0000
Message-Id: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are a large series of updates in functionality to the
atmel_mxt_ts touch driver. They apply cleanly to input/next.

These changes address some of the same issues that appear in the patchsets
submitted by Daniel Kurtz and Peter Meerwald. However, they go much further in
adding support for new objects, improving performance, and increasing
reliability. They have been regularly regression tested against old and new
chips which use the same protocol.

We also provide a set of user-space utilities as open source which are 
available from github and work well with this driver:
  https://github.com/atmel-maxtouch/obp-utils

Most of my focus in working on these changes has been to support Atmel's
customers, who tend not to be using the mainline kernel. Unfortunately this 
has generated somewhat of a backlog in getting these improvements into
mainline. My current focus is to get these improvements upstream and I have
time allocated to make any alterations as necessary. Since the scope of this
patchset is so large any upstream delta tends to cause a big rebasing effort.
I would suggest that I merge any useful improvements from the other patchsets
to make a combined patchset.

regards
--
Nick Dyer Senior Software Engineer
ITDev Hardware and Software Development Consultancy http://www.itdev.co.uk

