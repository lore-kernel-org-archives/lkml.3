Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3AVSax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:30:53 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52515 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3AVSav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:30:51 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/20] net: remove CONFIG_EXPERIMENTAL
Date: Tue, 22 Jan 2013 10:30:24 -0800
Message-Id: <1358879444-25834-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's what's left of the "remove experimental"[1] tree, all for netdev.

What would be the preference for taking these patches for linux-next?
Should they go via the netdev tree, or should I ask Greg KH to take them
via driver-core?

Thanks!

-Kees

[1] https://lkml.org/lkml/2012/10/23/580

