Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaKRSVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:21:32 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:41332 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbaKRSV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:21:29 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Nov 2014 10:21:05 -0800
X-Google-Sender-Auth: O464qhe2r-55XrWWvqjBXPr15tw
Message-ID: <CAB=NE6Wwec_sq4muj7kshhyLJttcf1CytTPWkjc_+Ub3dqn0tw@mail.gmail.com>
Subject: [ANN] Kernel integration now merged on backports
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-media@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wpan@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Full kernel integration is now merged as part of Linux
backports-20141114. I've written a bit about it [0] [1], what we need
now are users and developer to give this a good spin as we wind down
for the v3.19 release, which will be the first release that will
support kernel integration down to any kernel >= 3.0 -- for now you
can use the backports-20141114 tag which uses as base supported
drivers from next-20141114. What this will mean is that you can opt in
to integrate any device driver we support from any future backports
release into any of >= 3.0 kernel with full kconfig support, enabling
you to build everything as built-in. For all this you won't be using
the packaged releases [2], instead you'll use the git tree directly as
documented.

[0] http://www.do-not-panic.com/2014/11/automating-backport-kernel-integration.html
[1] https://backports.wiki.kernel.org/index.php/Documentation/integration
[2] https://backports.wiki.kernel.org/index.php/Documentation/packaging

  Luis
