Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3IEOsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:48:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab3IEOsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:48:00 -0400
Message-ID: <5228999B.8010300@redhat.com>
Date: Thu, 05 Sep 2013 16:47:55 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] mm: allow to set overcommit ratio more precisely
References: <1376925478-15506-1-git-send-email-jmarchan@redhat.com> <1376925478-15506-2-git-send-email-jmarchan@redhat.com> <52287E66.9010107@redhat.com> <52289824.20000@intel.com>
In-Reply-To: <52289824.20000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 04:41 PM, Dave Hansen wrote:
> On 09/05/2013 05:51 AM, Jerome Marchand wrote:
>> This patch adds the new overcommit_ratio_ppm sysctl variable that
>> allow to set overcommit ratio with a part per million precision.
>> The old overcommit_ratio variable can still be used to set and read
>> the ratio with a 1% precision. That way, overcommit_ratio interface
>> isn't broken in any way that I can imagine.
> 
> Looks like a pretty sane solution.  Could you also make a Documentation/
> update, please?

Damn! I forgot. Will do.

Thanks

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

