Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161939Ab3DEPyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 11:54:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:5052 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161903Ab3DEPyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:54:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="314190600"
Date: Fri, 5 Apr 2013 17:54:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-kernel@vger.kernel.org, gg@slimlogic.co.uk
Subject: Re: [PATCH 2/4] mfd: palmas: Change the DT node property names to
 follow the convention
Message-ID: <20130405155413.GH17363@zurbaran>
References: <1361164364-3175-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361164364-3175-1-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 18, 2013 at 10:42:44AM +0530, J Keerthy wrote:
> DT node properties should not have "_". Replacing them by "-".
> 
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>  drivers/mfd/palmas.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
