Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701Ab3DBGIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:08:55 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:50006 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3DBGIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:08:54 -0400
Date: Tue, 2 Apr 2013 02:08:49 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: xfs@oss.sgi.com
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <247719576.438259.1364882929749.JavaMail.root@redhat.com>
In-Reply-To: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
Subject: xfs deadlock on 3.9-rc5 running xfstests case #78
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: xfs deadlock on 3.9-rc5 running xfstests case #78
Thread-Index: ePds5FjhEOUFhfYr3RIc3zkWaEmy1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saw on almost all the servers range from x64, ppc64 and s390x with kernel
3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks like
something new broke this. Log is here with sysrq debug info.
http://people.redhat.com/qcai/stable/log

CAI Qian
