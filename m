Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3BLJC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:02:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41654 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab3BLJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:02:55 -0500
Date: Tue, 12 Feb 2013 10:02:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Add PEBSv2 record support v2
Message-ID: <20130212090250.GC19475@gmail.com>
References: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
 <1360265019-23865-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360265019-23865-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Add support for the v2 PEBS format. It has a superset of the v1 PEBS
> fields, but has a longer record so we need to adjust the code paths.

The changelog talks about a 'v2' PEBS format - the code talks 
about 'fmt2':

> +/*
> + * Same as pebs_record_nhm, with two additional fields.
> + */
> +struct pebs_record_fmt2 {

In light of the existing pebs_record_core and pebs_record_nhm 
naming a new perf_record_hsw would be more natural.

Or if numbered versions are used, all PEBS record hardware 
versions should be numbered.

Right now your extension makes it all look pretty inconsistent.

Thanks,

	Ingo
