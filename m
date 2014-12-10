Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbaLJWJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:09:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39532 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaLJWJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:09:04 -0500
Message-ID: <5488C478.9000209@canonical.com>
Date: Wed, 10 Dec 2014 17:08:56 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: JBottomley@Parallels.com
CC: steven@qumulo.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: [v3.16][v3.17][v3.18][ Regression]  scsi: handle flush errors properly
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello James,

A kernel bug report was opened against Ubuntu [0].  After a kernel
bisect, it was found that reverting the following commit resolved this bug:

commit 89fb4cd1f717a871ef79fa7debbe840e3225cd54
Author: James Bottomley <JBottomley@Parallels.com>
Date:   Thu Jul 3 19:17:34 2014 +0200

    scsi: handle flush errors properly

The regression was introduced as of v3.16 and still exits in the 3.18
kernel.  It has also made it's way into the stable kernels.

I was hoping to get your feedback, since you are the patch author.  Do
you think gathering any additional data will help diagnose this issue,
or would it be best to submit a revert request?


Thanks,

Joe

[0] http://pad.lv/1366538

