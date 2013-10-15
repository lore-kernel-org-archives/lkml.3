Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab3JOQzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:55:00 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38337 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3JOQy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:54:59 -0400
Date: Tue, 15 Oct 2013 22:24:35 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131015165435.GA2777@naverao1-tp.ibm.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101516-2000-0000-0000-00000E1EBCB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/11 02:32AM, Chen Gong wrote:
> Use trace interface to elaborate all H/W error related
> information.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
<snip>
> +TRACE_EVENT(extlog_mem_event,
> +	TP_PROTO(u32 etype,
> +		char *dimm_loc,
> +		const uuid_le *fru_id,
> +		char *fru_text,
> +		u64 error_count,
> +		u32 severity,
> +		u64 phy_addr,
> +		char *mem_loc),

[Adding Mauro...]

This looks very similar to the trace event I wrote a while back,
which was similar to the one provided by ghes_edac:
http://thread.gmane.org/gmane.linux.kernel.pci/24616

Seems to me this has the same issues we previously discussed w.r.t
EDAC conflicts...


Regards,
Naveen

