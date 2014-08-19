Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaHSKvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:51:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:40363 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaHSKvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:51:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="586839395"
Date: Tue, 19 Aug 2014 13:50:59 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] gpio-lynxpoint: enable input sensing in resume
Message-ID: <20140819104958.GN1660@lahna.fi.intel.com>
References: <1408446001-4998-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408446001-4998-1-git-send-email-mathias.nyman@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 02:00:01PM +0300, Mathias Nyman wrote:
> It appears that input sensing bit might be reset during
> suspend/resume. Set input sensing again for all requested gpios
> in resume
> 
> Tested-by: Jerome Blin <jerome.blin@intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
