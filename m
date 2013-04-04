Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab3DDDcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 23:32:42 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39974 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712Ab3DDDcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 23:32:41 -0400
Date: Thu, 4 Apr 2013 09:02:27 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, adrian.m.negreanu@intel.com,
        Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 0/9] uretprobes: Return uprobes implementation
Message-ID: <20130404033227.GB17518@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1365004839-21982-1-git-send-email-anton@redhat.com> <20130403174552.GA9984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403174552.GA9984@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040403-5806-0000-0000-00002096A9E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 07:45:52PM +0200, Oleg Nesterov wrote:
> On 04/03, Anton Arapov wrote:

...

> Looks fine to me. I am going to add this to
> git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> Ananth. "4/9 uretprobes/ppc" looks "obviously correct", but could you
> please review and ack/nack ?

Oleg,
4/9 is fine; I have acked it.

Ananth

