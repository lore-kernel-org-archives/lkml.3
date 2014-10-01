Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaJAA7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 20:59:33 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41963 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaJAA7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 20:59:32 -0400
Date: Tue, 30 Sep 2014 17:59:05 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        dev@codyps.com, linuxppc-dev@lists.ozlabs.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [v2,2/4] Simplify catalog_read()
Message-ID: <20141001005905.GB4441@us.ibm.com>
References: <1411586681-21262-3-git-send-email-sukadev@linux.vnet.ibm.com>
 <20141001003213.A8F78140273@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001003213.A8F78140273@ozlabs.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100100-7182-0000-0000-00000096EACD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [mpe@ellerman.id.au] wrote:
| > @@ -203,6 +125,7 @@ static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
| >  
| >  	page_offset = offset / 4096;
| >  	page_count  = count  / 4096;
| 
| I don't see where page_count is used.

Yes, I will remove it.

| 
| > +	offset_in_page = count % 4096;
| 
| Shouldn't offset_in_page be based on offset ?

Yes. I will fix that.

Thanks,

Sukadev

