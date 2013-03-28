Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3C1TKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:10:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab3C1TKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:10:12 -0400
Message-ID: <51549533.4080003@redhat.com>
Date: Thu, 28 Mar 2013 15:08:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/13] rwsem: move rwsem_down_failed_common code into
 rwsem_down_{read,write}_failed
References: <1363344869-15732-1-git-send-email-walken@google.com> <1363344869-15732-4-git-send-email-walken@google.com>
In-Reply-To: <1363344869-15732-4-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:54 AM, Michel Lespinasse wrote:
> Remove the rwsem_down_failed_common function and replace it with two
> identical copies of its code in rwsem_down_{read,write}_failed.
>
> This is because we want to make different optimizations in
> rwsem_down_{read,write}_failed; we are adding this pure-duplication
> step as a separate commit in order to make it easier to check the
> following steps.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

