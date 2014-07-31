Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaGaLNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:13:35 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:35380 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaGaLNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:13:33 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [RFC] increase perf kvm stat accuracy
Date: Thu, 31 Jul 2014 13:13:50 +0200
Message-Id: <1406805231-10675-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073111-5024-0000-0000-000000DA3B1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my s390 kvm system most of the kvm exits are in the range
of 0 or 1 microseconds. Can we increase the accuracy by 2 
additional digits?

Opinions?


Christian Borntraeger (1):
  KVM: perf/stat: Properly show submicrosecond times

 tools/perf/builtin-kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.4.2

