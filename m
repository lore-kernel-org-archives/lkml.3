Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3H0Nm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:42:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:30646 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab3H0Nmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:42:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,968,1367996400"; 
   d="scan'208";a="287342172"
Date: Tue, 27 Aug 2013 15:42:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] nfc: standardize logging styles
Message-ID: <20130827134248.GA20329@zurbaran>
References: <1365180413.2075.5.camel@joe-AO722>
 <cover.1365189658.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1365189658.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Fri, Apr 05, 2013 at 12:27:36PM -0700, Joe Perches wrote:
> Fix some defects in the logging too
> 
> Joe Perches (3):
>   nfc: Replace nfc_dev_dbg with dev_dbg, remove function tracing
>   nfc: Convert nfc_dev_info and nfc_dev_err to nfc_<level>
>   nfc: Standardize logging style
All 3 patches applied, sorry for missing those ones.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
