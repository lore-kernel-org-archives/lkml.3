Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab3FER5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:57:03 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:39038 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757121Ab3FERsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:14 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Atmel updates to atmel_mxt_ts touch controller driver - v5 Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>, Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Date: Wed,  5 Jun 2013 18:36:53 +0100
Message-Id: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are an updated series of patches to the atmel_mxt_ts
touch driver. They should apply cleanly to input/next.

This is a combined patchset, I've been working to merge my changes with the
changes from the Chromium team. It's undergone a lot of testing and review
over the last few months and I believe it is now ready to go upstream.

Most of these changes have been maintained and tested out-of-tree in some form
for a long time. I apologise for the backlog.

We also provide a set of user-space utilities as open source which are
available from github and work well with this driver:
  https://github.com/atmel-maxtouch/obp-utils

You can see the in-between versions at
  https://github.com/ndyer/linux/

regards
--
Nick Dyer Senior Software Engineer
ITDev Hardware and Software Development Consultancy http://www.itdev.co.uk


