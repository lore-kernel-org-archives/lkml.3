Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab3CLDkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:40:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34092 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3CLDks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:40:48 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 11 Mar 2013 20:40:26 -0700
X-Google-Sender-Auth: iH26qE35ezIWZKZYtDe8r5GWGz4
Message-ID: <CAB=NE6Vj1P0fDDvuVqsDcvOhHYJf4=WvGnzM1963RrLvtd6XHg@mail.gmail.com>
Subject: compat-drivers based on v3.9-rc2
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've kicked out compat-drivers releases based on v3.9-rc2 [0], be sure
to use the temporary release page [1] while we get one in place on
kernel.org. We are on rc2 now... please test and report any issues!
Please submit your patches for anything you think is critical but not
'stable' material for inclusion of those patches into their respective
directory, if unclear please read the additional-patches documentation
[2]. This should allow us developers to focus on convincing PHBs to
always work upstream without having them to persuade their own
'private' releases to customers / your mom that typically do carry
these patches but they never get merged back upstream.

[0] https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.9-rc2/
[1] http://drvbp1.linux-foundation.org/~mcgrof/rel-html/compat-drivers/
[2] https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers/additional-patches

  Luis
