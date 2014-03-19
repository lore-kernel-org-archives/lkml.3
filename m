Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaCSUcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:32:22 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:34438 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaCSUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:32:18 -0400
Date: Wed, 19 Mar 2014 16:32:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>, linux-ide@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH -next] libata.h: add stub for ata_sas_port_resume
Message-ID: <20140319203213.GC3656@mtj.dyndns.org>
References: <5329D7F1.4030400@infradead.org>
 <20140319175852.GD19874@htj.dyndns.org>
 <1395252855.21554.1.camel@dwillia2-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395252855.21554.1.camel@dwillia2-mobl2.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 11:14:15AM -0700, Dan Williams wrote:
> Subject: libata: remove unused ata_sas_port_async_resume() stub
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Commit bc6e7c4b0d1a "libata, libsas: kill pm_result and related cleanup"
> renamed ata_sas_port_async_resume() to ata_sas_port_resume(), but missed
> a CONFIG_PM=n stub conversion.  Randy fixed that up in commit
> a5a6569959fc "libata.h: add stub for ata_sas_port_resume", but missed
> the deletion of the now unused ata_sas_port_async_resume() routine.
> 
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Applied to libata/for-3.15.

Thanks.

-- 
tejun
