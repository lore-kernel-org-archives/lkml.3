Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab3BZHyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:54:35 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57288 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3BZHye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:54:34 -0500
MIME-Version: 1.0
In-Reply-To: <512C56AF.1030801@oracle.com>
References: <EB937501617BFC44BE90EDA24CA6A13A0117EB@SGSIMBX003.nsn-intra.net>
	<512C56AF.1030801@oracle.com>
Date: Tue, 26 Feb 2013 08:54:32 +0100
Message-ID: <CAFLxGvyQmPz_iK26NavuRdBWAFiWzmt8BMfL8f6rg_Qm4LF7WQ@mail.gmail.com>
Subject: Re: [Ocfs2-users] Kernel panic due to ocfs2
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: "Ramappa, Ravi (NSN - IN/Bangalore)" <ravi.ramappa@nsn.com>,
        "ocfs2-users@oss.oracle.com" <ocfs2-users@oss.oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, david@sigma-star.at
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 7:31 AM, Srinivas Eeda <srinivas.eeda@oracle.com> wrote:
> This is due to a race in lock mastery/purge. I have recently fixed this
> problem but haven't yet submitted the patch to mainline. Please file a
> Service request with Oracle to get a one-off fix.

Please submit the patch immediately.
Why does one need a f§&"!#$ SR from Oracle to have this fixed?
OCFS2 is mainline...

-- 
Thanks,
//richard
