Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaBTMPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:15:12 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31373 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaBTMPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:15:10 -0500
Date: Thu, 20 Feb 2014 15:14:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: jejb@kernel.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        Tomas Henzl <thenzl@redhat.com>,
        =?utf-8?B?5ZCz56Kn5ra8?= <billion.wu@areca.com.tw>
Subject: Re: [PATCH v1.3 1/11] arcmsr: Revise interrupt service routine to
 fix command timeout
Message-ID: <20140220121435.GY26776@mwanda>
References: <CAKiknE9pf-hQOTcxbw8WnHECDJDZMHJA-TBEPeg7+q5nb+AoCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKiknE9pf-hQOTcxbw8WnHECDJDZMHJA-TBEPeg7+q5nb+AoCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 08:05:05PM +0800, 黃清隆 wrote:
> From: Ching <ching2048@areca.com.tw>
> 
> Rewrite interrupt service routine to fix command timeout on controller too
> heavy loading.
> 
> Singed-off-by: Ching <ching2048@areca.com.tw>

Your email client screwed up the whitespace completely.  Read
Documentation/email-clients.txt or use `git send-email`
http://www.freedesktop.org/wiki/Software/PulseAudio/HowToUseGitSendEmail/

There are also many unrelated white space changes in this patch.

regards,
dan carpenter

