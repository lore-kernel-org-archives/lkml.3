Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaBKU3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:29:31 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52424 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973AbaBKU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:29:28 -0500
Message-ID: <1392150566.9682.44.camel@x220>
Subject: What commit dropped config PLAT_SPEAR_SINGLE?
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>
Date: Tue, 11 Feb 2014 21:29:26 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 20:29:27.0167 (UTC) FILETIME=[F58AE8F0:01CF2767]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) config PLAT_SPEAR_SINGLE was added in commit 5b65fc560398 ("ARM:
spear: use multiplatform configuration options."). That commit was added
in the v3.10 release cycle.

1) But in v3.10 config PLAT_SPEAR_SINGLE was already gone.

2) But I can't figure out which commit removed it. I guess it's some
merge commit that somehow is not included when I do (tree wide) "git log
-p" searches. What git trick will uncover that mysterious commit?


Paul Bolle

