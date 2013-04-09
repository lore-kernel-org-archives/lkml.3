Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878Ab3DIHKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:10:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:7636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934744Ab3DIHKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:10:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,436,1363158000"; 
   d="scan'208";a="315161145"
Date: Tue, 9 Apr 2013 09:10:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: drop "select PMIC_DA9055"
Message-ID: <20130409071035.GE24058@zurbaran>
References: <1362846754.3137.9.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362846754.3137.9.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sat, Mar 09, 2013 at 05:32:34PM +0100, Paul Bolle wrote:
> The Kconfig entry for DA9055 PMIC Support selects PMIC_DA9055. That was
> probably inspired by the similar select statement in the entry for
> DA9052/53 PMIC with I2C. But the DA9055 PMIC only comes in an I2C
> variant and its driver doesn't need a separate Kconfig symbol for shared
> code. In any case, this select can be dropped as PMIC_DA9055 doesn't
> exist.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested with "git grep" only.
> 
> 1) Note that the DA9052 and DA9055 drivers all have code for module
> support, but their Kconfig entries only allow them to be builtin. Can't
> these entries be made tristate? If not, shouldn't the code for module
> support be removed?
> 
>  drivers/mfd/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
Patch applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
