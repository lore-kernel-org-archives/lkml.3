Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab3CHHH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:07:58 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56863 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3CHHH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:07:56 -0500
Date: Thu, 7 Mar 2013 23:07:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 05/14] x86, ACPI: Find acpi tables in initrd early at
 head_32.S/head64.c
Message-ID: <20130308070752.GO14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-6-git-send-email-yinghai@kernel.org>
 <20130308055729.GG14556@mtj.dyndns.org>
 <CAE9FiQVeXTbLYQM=t1ZM6t7q51vvv65bicuVutbeSGZv1fT6zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVeXTbLYQM=t1ZM6t7q51vvv65bicuVutbeSGZv1fT6zA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 11:02:15PM -0800, Yinghai Lu wrote:
> > Also, does it really have to be called from head_32.S?  No way this
> > can be done after entering C code?  It would be great if you can
> > explain overall design choices in the head message (and important
> > patches).
> 
> have to be with head_32.S and it is with 32bit flat mode, so could access
> 4G blow without setting page table.
> 
> Will try add to more in the change log.

Yes, please.  In the comment too.

-- 
tejun
