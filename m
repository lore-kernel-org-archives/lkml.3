Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaKPTNi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:13:38 -0500
Received: from mout.web.de ([212.227.15.14]:50159 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbaKPTNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:13:37 -0500
Message-ID: <5468F756.8070807@users.sourceforge.net>
Date: Sun, 16 Nov 2014 20:13:26 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH v2 0/2] kernel-trace: Fixes around the jump label "fail_address_parse"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5468ABBD.6000903@users.sourceforge.net> <alpine.DEB.2.10.1411161656340.2364@hadrien>
In-Reply-To: <alpine.DEB.2.10.1411161656340.2364@hadrien>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:EKQHQ1UDWWOovPeLPk+Y9RwVLD93Cgo7K0tp0Hoh5xEHdRGXZtj
 E4CJKkiwk5UY0Qikdb71RDAwNzj4EOZhuNY5YoOPzlb25gWtVNvmJ/h/0D7+JXujOkjUUJM
 Nsoq9MYDiekOIq20T4I1mY7mD9J8G/p51Xew5Imy21miHw2NqmDf74YD4DMo/htj3I7Fxd3
 hXQIPnVvb+O2h/omBCIMg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 16 Nov 2014 19:56:15 +0100

Another update suggestion was taken into account after a patch was applied
from static source code analysis.

Markus Elfring (2):
  kernel-trace: Deletion of an unnecessary check before the function
    call "iput"
  kernel-trace: Less calls for iput() in create_trace_uprobe() after
    error detection

 kernel/trace/trace_uprobe.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

-- 
2.1.3


