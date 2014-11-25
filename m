Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaKYS2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:28:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaKYS2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:28:02 -0500
Message-ID: <1416940024.26209.2.camel@linux-t7sj.site>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice
From: Davidlohr Bueso <dave@stgolabs.net>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, corbet@lwn.net, mingo@redhat.com,
        hpa@zytor.com, peterz@infradead.org, riel@redhat.com,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Date: Tue, 25 Nov 2014 10:27:04 -0800
In-Reply-To: <54749617.5030309@oracle.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <alpine.DEB.2.11.1411242317380.6439@nanos> <54749617.5030309@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 07:45 -0700, Khalid Aziz wrote:
> This solution has been used by both database and java on other OSs and 
> has shown performance improvement. Andrew had asked for performance 
> numbers on Linux with this patch last time I sent this out and it took 
> me a while to get performance folks to run a full TPC-C workload. They 
> did see a 3% improvement in tpcc as I noted in commit log and that is a 
> significant improvement.

3% for such a change seems pretty worthless... I would have expected
this having to impact performance much more.

Thanks,
Davidlohr

