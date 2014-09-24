Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaIXI1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:27:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43877 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaIXI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:44 -0400
X-AuditID: cbfee61a-f79c06d000004e71-2f-5422807eadfe
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 0/3] thermal: fix: Various fixes for thermal subsystem
Date: Wed, 24 Sep 2014 10:27:09 +0200
Message-id: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t9jAd26BqUQg84PGhYbZ6xntZh/5Rqr
	xZtH3BZvHm5mtLi8aw6bxefeI4wWTx72sTmwe+ycdZfdY/Gel0we66a9Zfbo27KK0ePzJrkA
	1igum5TUnMyy1CJ9uwSujL5fm5kK3jFXNDz8yNbA2MbcxcjJISFgIrF+0TQoW0ziwr31bF2M
	XBxCAosYJSZNew7ldDFJnD/czApSxSagJ/H57lOmLkYODhEBb4ktazhAapgFbjBKTOmfzARS
	IyzgJrHix352EJtFQFXi/eVpYHFeoPjp5bvYIbYpSnQ/m8A2gZF7ASPDKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzgIHkmtYNxZYPFIUYBDkYlHt4J4kohQqyJZcWVuYcYJTiYlUR4T5QC
	hXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTD2mW684ufV
	ktGx0ftF10ubs4HSWy+mq5z1m74ufWMbv7AwX0qvgGfE+esngm3vZP0wVT9i+fWG5Rqz/csU
	oys+7cxddHy2zK9pH3bu+Cq1aq/cuRe7AnTlXkslxunuvfKvZqbL17cP913Sl8jRN7M+/Et0
	T+ehbbX/JURDFv19WNjXtNNC5xGrEktxRqKhFnNRcSIAfMHhCg4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little patch series comprises fixes for step_wise governor and
thermal core.

Lukasz Majewski (3):
  thermal: step_wise: fix: Prevent from binary overflow when trend is
    dropping
  thermal: core: fix: Initialize the max_state variable to 0
  thermal: core: fix: Check return code of the ->get_max_state()
    callback

 drivers/thermal/step_wise.c    | 2 +-
 drivers/thermal/thermal_core.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.0.0.rc2

