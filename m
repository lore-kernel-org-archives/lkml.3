Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3J0TdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:33:09 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:50249 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab3J0TdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:33:06 -0400
Message-ID: <526D6A5E.5000100@hauke-m.de>
Date: Sun, 27 Oct 2013 20:32:46 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [ANN] backports-20131025 released
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally backports is in sync with linux-next again, we just did the
backports-20131025 release which is based on linux-next next-20131025.

The release can be found here:
https://www.kernel.org/pub/linux/kernel/projects/backports/2013/10/25/backports-20131025.tar.bz2

There are also older releases based on older linux-next releases.

The source code can temporary be found here:
https://github.com/hauke/backports

Currently Stephen Rothwell, the original author of the linux-next tree,
is on vacation, but Thierry Reding took over [1] and backports is based
on his releases [2] now.

Now getting new stable releases based on kernel 3.10, 3.11 and 3.12 is
the next goal.

This release and further releases will not contain any GPU drivers any
more, it was too much work to backport them to older kernel versions and
it looked like that code did not had any users.

More information can be found in our wiki:
https://backports.wiki.kernel.org/index.php/Main_Page

Hauke

[1]: https://lkml.org/lkml/2013/9/30/179
[2]: git://gitorious.org/thierryreding/linux-next.git
