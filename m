Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965234Ab3DHOtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:49:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:58793 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965220Ab3DHOtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:49:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="283132593"
Date: Mon, 8 Apr 2013 16:49:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Michael Hennerich <michael.hennerich@analog.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd:adp5520: Restore mode bits on resume
Message-ID: <20130408144915.GT24058@zurbaran>
References: <1361271082-29905-1-git-send-email-lars@metafoo.de>
 <512379AC.6010304@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512379AC.6010304@analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael, Lars,

On Tue, Feb 19, 2013 at 02:10:04PM +0100, Michael Hennerich wrote:
> On 02/19/2013 11:51 AM, Lars-Peter Clausen wrote:
> >The adp5520 unfortunately also clears the BL_EN bit when the nSTNDBY bit is
> >cleared. So we need to make sure to restore it during resume if it was set
> >before suspend.
> >
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> >---
> >  drivers/mfd/adp5520.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
