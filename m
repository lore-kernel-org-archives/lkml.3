Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaEHNQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:16:34 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36676 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaEHNQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:16:32 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-3a-536b83adf9dc
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: viro@zeniv.linux.org.uk, ebiederm@xmission.com,
        linux-security-module@vger.kernel.org, eparis@redhat.com,
        zohar@linux.vnet.ibm.com
Cc: dmitry.kasatkin@gmail.com, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/1] fix IMA + Apparmor kernel panic
Date: Thu, 08 May 2014 16:16:53 +0300
Message-id: <cover.1399554584.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xK7prm7ODDV7MkLK49Xcvs8WXpXUW
	/7e1sFtM3N7GYnF51xw2iw89j9gszv89zmrxacUkZgcOj52z7rJ7PDi0mcXj/b6rbB59W1Yx
	enzeJOcx5VA7i8emJ2+ZAtijuGxSUnMyy1KL9O0SuDJ2PT/NXDCTuWLz3Y/MDYxnmboYOTgk
	BEwkfj9l62LkBDLFJC7cWw9kc3EICSxllNg2dy0jhNPJJNG4ZjsLSBWbgJ7EhuYf7CAJEYEu
	RokXG46xgiSYBdIlfn/+zAhiCwNNXTJ5DzPIBhYBVYm+1+YgYV4BS4mpXc+ZILYpSCz7spZ5
	AiP3AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghAfR1B+PSY1aHGAU4GJV4eBfIZAQL
	sSaWFVfmHmKU4GBWEuG9UpkdLMSbklhZlVqUH19UmpNafIiRiYNTqoEx+cP+TXUl7bmLbink
	m9SJKPaZXmTc8WbBPgNBy5CMk1ETfQ2KZbbO2LkqPetR6MFTukt9G+tDnH9UNTgcPDh9Vpu4
	Zu7yF5Kb7LneH1ielGr/tU1DZj1fy8tdr+a7+KqaL352YVLo37WnHd0fWGbwf0zWXSRiWL+V
	7/eq69eVXixd8Cr6/K41SizFGYmGWsxFxYkAtMNjTv4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following patch replaces IMA usage of kernel_read() with special
version which skips security check that triggers kernel panic
when Apparmor and IMA appraisal are enabled together.

- Dmitry

Dmitry Kasatkin (1):
  ima: introduce ima_kernel_read()

 security/integrity/ima/ima_crypto.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

-- 
1.8.3.2

