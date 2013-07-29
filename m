Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3G2IeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:34:01 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50814 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3G2Id7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:33:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130726113717.GN13468@dastard>
References: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
	<20130726020318.GD21982@dastard>
	<CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
	<20130726113717.GN13468@dastard>
Date: Mon, 29 Jul 2013 16:33:58 +0800
Message-ID: <CAEH94Lj27DCzCiWxwerEgwsExtdtviB_+S4bDbxg-wwq445rSA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix an assertion failure
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 7:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jul 26, 2013 at 02:01:23PM +0800, Zhi Yong Wu wrote:
>> No, it still raised the same assertion as below:
>>
>> [  521.715103] XFS: Assertion failed: !(bip->bli_item.li_flags &
>> XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 940
>
> How are you reproducing it?
>
> Can you take an event trace with trace-cmd and attach the output of
> the report?
After kernel base is switched to Linux 3.11-rc3, when i try to take
event trace with trace-cmd, that issue doesn't appear any more in my
environment. :)

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
