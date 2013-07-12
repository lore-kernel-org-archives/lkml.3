Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223Ab3GLRbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:31:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46728 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932650Ab3GLRbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:31:48 -0400
Message-ID: <1373650307.2614.10.camel@joe-AO722>
Subject: [PATCH] gps6507x.txt: Remove executable bits
From: Joe Perches <joe@perches.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 10:31:47 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation shouldn't be executable.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/Documentation/devicetree/bindings/mfd/tps6507x.txt
old mode 100755
new mode 100644


