Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaCMSRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:17:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49142 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbaCMSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:17:22 -0400
Message-ID: <5321F62F.6040804@infradead.org>
Date: Thu, 13 Mar 2014 11:17:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>, qla2xxx-upstream@qlogic.com
Subject: Re: mmotm 2014-03-12-16-04 uploaded (scsi/qla2xxx)
References: <20140312230510.69CD831C078@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20140312230510.69CD831C078@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 04:05 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-03-12-16-04 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 
> You will need quilt to apply these patches to the latest Linus release (3.x
> or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series
> 
> The file broken-out.tar.gz contains two datestamp files: .DATE and
> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> followed by the base kernel version against which this patch series is to
> be applied.
> 

from linux-next:

on i386:

drivers/scsi/qla2xxx/qla_init.c:5295:7: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'uint32_t' [-Wformat]
drivers/scsi/qla2xxx/qla_init.c:5562:6: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'int' [-Wformat]
drivers/scsi/qla2xxx/qla_init.c:5597:7: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'uint32_t' [-Wformat]
drivers/scsi/qla2xxx/qla_attr.c:162:6: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'size_t' [-Wformat]
drivers/scsi/qla2xxx/qla_attr.c:203:7: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'size_t' [-Wformat]
drivers/scsi/qla2xxx/qla_attr.c:207:6: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'size_t' [-Wformat]



-- 
~Randy
