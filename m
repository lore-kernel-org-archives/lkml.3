Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbaLJVM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:12:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29065 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691AbaLJVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:12:54 -0500
To: Long Li <longli@microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
Date: Wed, 10 Dec 2014 16:12:32 -0500
In-Reply-To: <1418200705-488-1-git-send-email-longli@microsoft.com> (Long Li's
	message of "Wed, 10 Dec 2014 00:38:25 -0800")
Message-ID: <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Long" == Long Li <longli@microsoft.com> writes:

Long> MSFT targets currently claim SPC-2 compliance while they implement
Long> post SPC-2 features. With this patch we can correctly handle
Long> WRITE_SAME_16 issues.

Handle the issues or handle WRITE SAME(10/16)?

+	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},

Is that version field meaningful or is it safe for us to inquire about
VPD pages without problems on older versions?

-- 
Martin K. Petersen	Oracle Linux Engineering
