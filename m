Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3IEOl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:41:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:55110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab3IEOlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:41:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,847,1371106800"; 
   d="scan'208";a="373942970"
Message-ID: <52289824.20000@intel.com>
Date: Thu, 05 Sep 2013 07:41:40 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] mm: allow to set overcommit ratio more precisely
References: <1376925478-15506-1-git-send-email-jmarchan@redhat.com> <1376925478-15506-2-git-send-email-jmarchan@redhat.com> <52287E66.9010107@redhat.com>
In-Reply-To: <52287E66.9010107@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 05:51 AM, Jerome Marchand wrote:
> This patch adds the new overcommit_ratio_ppm sysctl variable that
> allow to set overcommit ratio with a part per million precision.
> The old overcommit_ratio variable can still be used to set and read
> the ratio with a 1% precision. That way, overcommit_ratio interface
> isn't broken in any way that I can imagine.

Looks like a pretty sane solution.  Could you also make a Documentation/
update, please?
