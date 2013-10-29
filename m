Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3J2TWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:22:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3J2TWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:22:49 -0400
Message-ID: <52700AD2.6000703@canonical.com>
Date: Tue, 29 Oct 2013 15:21:54 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: hpa@zytor.com, bernd.schubert@itwm.fraunhofer.de, JBottomley@Parallels.com,
        LKML <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal.mostafa@canonical.com>,
        linux-scsi@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: Subject:  [v3.8][v3.11][Regression] [SCSI] sd: Update WRITE SAME
 heuristics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

A bug was opened against the Ubuntu kernel[0].  After a kernel bisect,
it was found that reverting the following commit resolved this bug:

commit 66c28f97120e8a621afd5aa7a31c4b85c547d33d
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Thu Jun 6 22:15:55 2013 -0400

    [SCSI] sd: Update WRITE SAME heuristics


The regression was introduced as of v3.11-rc1, but it also made it's way
into the stable trees.

I see that you are the author of this patch, so I wanted to run this by
you.  I was thinking of requesting a revert for v3.12, but I wanted to
get your feedback first.


Thanks,

Joe

[0] http://pad.lv/1237392
