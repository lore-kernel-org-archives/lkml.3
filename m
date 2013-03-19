Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417Ab3CSWNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:13:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43370 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933880Ab3CSWNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:13:53 -0400
Message-ID: <1363731232.16270.14.camel@joe-AO722>
Subject: [PATCH] Documentation: Remove executable bit from tps6507x.txt
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 15:13:52 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Text files shouldn't be executable.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/devicetree/bindings/mfd/tps6507x.txt | 0
 1 file changed, 0 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/Documentation/devicetree/bindings/mfd/tps6507x.txt
old mode 100755
new mode 100644


