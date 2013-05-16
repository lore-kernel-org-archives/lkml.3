Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3EPWzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:55:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:37665 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3EPWy7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:54:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="338908784"
From: "Ralston, James D" <james.d.ralston@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Peter Tyser <ptyser@xes-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Heasley, Seth" <seth.heasley@intel.com>
Subject: RE: [PATCH v2] lpc_ich: Watchdog/GPIO patch for Intel Avoton SoC
Thread-Topic: [PATCH v2] lpc_ich: Watchdog/GPIO patch for Intel Avoton SoC
Thread-Index: AQHOUoMWQ9ZmEHmdE0OfCES40Kds0pkIa66Q
Date: Thu, 16 May 2013 22:54:56 +0000
Message-ID: <92A8E3E1132F2F478648ABA9A4E1EC998CCEC0A2@ORSMSX105.amr.corp.intel.com>
References: <1368128333-1765-1-git-send-email-james.d.ralston@intel.com>
 <20130516221655.GT22822@zurbaran>
In-Reply-To: <20130516221655.GT22822@zurbaran>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good to hear. Thanks!

James Ralston


-----Original Message-----
From: Samuel Ortiz [mailto:sameo@linux.intel.com] 
Sent: Thursday, May 16, 2013 3:17 PM
To: Ralston, James D
Cc: Peter Tyser; linux-kernel@vger.kernel.org; Heasley, Seth
Subject: Re: [PATCH v2] lpc_ich: Watchdog/GPIO patch for Intel Avoton SoC

Hi James,

On Thu, May 09, 2013 at 12:38:53PM -0700, James Ralston wrote:
> This patch adds the LPC Controller Device IDs for Watchdog and GPIO for the Intel Avoton SoC.
> 
> Signed-off-by: James Ralston <james.d.ralston@intel.com>
> ---
> Change notes for v2:
> *corrected version number
> 
>  drivers/mfd/lpc_ich.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
Applied to my mfd-next tree, it should make it to Linux 3.11.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
