Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3LFPkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:40:24 -0500
Received: from exchange10.columbia.tresys.com ([216.30.191.171]:38195 "EHLO
	exchange10.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768Ab3LFPkV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:40:21 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 10:40:21 EST
From: William Roberts <WRoberts@tresys.com>
To: William Roberts <bill.c.roberts@gmail.com>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rgb@redhat.com" <rgb@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
CC: "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>
Subject: RE: [PATCH] - auditing cmdline
Thread-Topic: [PATCH] - auditing cmdline
Thread-Index: AQHO76L60+nsjxXq70yCKV3N/pPBR5pHUWxQ
Date: Fri, 6 Dec 2013 15:34:32 +0000
Message-ID: <A8856C6323EFE0459533E910625AB930347FDF@Exchange10.columbia.tresys.com>
References: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
In-Reply-To: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.143.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent out 3 patches on 12/2/2013. I didn't get any response. I thought I added the right people based on get_maintainers script.

Can anyone comment on these or point me in the right direction?

RGB, Can you at least ACK the audit subsystem patch " audit: Audit proc cmdline value"?

Thank you,
Bill

-----Original Message-----
From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On Behalf Of William Roberts
Sent: Monday, December 02, 2013 1:11 PM
To: linux-audit@redhat.com; linux-mm@kvack.org; linux-kernel@vger.kernel.org; rgb@redhat.com; viro@zeniv.linux.org.uk
Cc: sds@tycho.nsa.gov
Subject: [PATCH] - auditing cmdline

This patch series relates to work started on the audit mailing list.
It eventually involved touching other modules, so I am trying to pull in those owners as well. In a nutshell I add new utility functions for accessing a processes cmdline value as displayed in proc/<self>/cmdline, and then refactor procfs to use the utility functions, and then add the ability to the audit subsystem to record this value.

Thanks for any feedback and help.

[PATCH 1/3] mm: Create utility functions for accessing a tasks
[PATCH 2/3] proc: Update get proc_pid_cmdline() to use mm.h helpers
[PATCH 3/3] audit: Audit proc cmdline value

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
