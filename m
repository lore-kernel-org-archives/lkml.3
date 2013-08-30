Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3H3E3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:29:50 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49524 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3H3E3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:29:48 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 0/6] extcon-gpio: Add devicetree support
Date: Thu, 29 Aug 2013 21:29:32 -0700
Message-Id: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first three patches of this series are either cleanup or add functionality
unrelated to devicetree support and should hopefully be acceptable as-is or with
minor modifications.

Patch 1 of this series is a tiny cleanup patch.
Patch 2 adds support for hardware debounce. If the gpio chip supports debounce,
use it instead of software debounce.
Patch 3 adds support for low-active presence detect signals.

Patch 4 and 5 add devicetree support. Patch 4 is the actual code and patch 5
describes devicetree bindings. Both could possibly be merged into a single
patch.

Patch 6 adds possible properties for connectors supporting multiple cable
types to the devicetree bindings document. This is purely for discussion
and would be implemented in a separate patch. While I don't need this code
for our application, I would be happy to provide it if the community sees
value in it.
