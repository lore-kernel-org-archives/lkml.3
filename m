Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaHKNBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:01:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32157 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaHKNB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:01:29 -0400
Date: Mon, 11 Aug 2014 15:54:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Srikrishan Malik <srikrishanmalik@gmail.com>,
        Joe Perches <joe@perches.com>, greg@kroah.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] staging: lustre: Fix misplaced opening brace
 warnings
Message-ID: <20140811110745.GJ11899@mwanda>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
 <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>
 <20140806201813.GE4856@mwanda>
 <20140807153136.GB4185@mordor.in.ibm.com>
 <20140807160103.GG4856@mwanda>
 <1407429343.2736.28.camel@joe-AO725>
 <20140811105706.GA17691@mordor.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811105706.GA17691@mordor.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 04:27:06PM +0530, Srikrishan Malik wrote:
> This patch set is aimed at removing checkpatch issues from files in
> lustre/lustre/mdc.
> 
> Is it ok if I just fix those in this set and post another patch set
> to take care of other issues identified in review?

checkpatch fixes are worthless if they don't make the code better for
human readers.

> 
> - removing typedef for ldlm_policy_data_t will touch many other
> files/dirs which were not initially targeted for this patch set.

Yeah.  You're right.  This should be done in a separate patch because
it doesn't completely fall under the "cleanup variable declarations in
mdc_enqueue()" header.

> - There can be a separate patch to remove __u64.

It's all part of the same thing "variable declarations in that
function."

regards,
dan carpenter
