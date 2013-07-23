Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab3GWUbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:31:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:30881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab3GWUbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:31:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,730,1367996400"; 
   d="scan'208";a="375282918"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH 02/48] staging/lustre/obdclass: restore lu_ref
Thread-Topic: [PATCH 02/48] staging/lustre/obdclass: restore lu_ref
Thread-Index: AQHOhvX22ZueCadhDkqfyap0NL7laJlzH3oA//+qhAA=
Date: Tue, 23 Jul 2013 20:31:15 +0000
Message-ID: <CE1443D8.57081%andreas.dilger@intel.com>
In-Reply-To: <20130723193712.GA9385@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.141.148]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2ACF3A707CBD484787E01D8497C011EF@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/07/23 1:37 PM, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
wrote:

>On Tue, Jul 23, 2013 at 12:06:23AM +0800, Peng Tao wrote:
>> lu_ref.[ch] were mistakenly removed by coan2. Add them back and guard
>> with CONFIG_LUSTRE_DEBUG_LU_REF_CHECK.
>
>Ick, why?  Why not use the in-kernel infrastructure for this type of
>thig, _iff_ you really need it.
>
>Why do you need this at all, isn't the reference code fully debugged by
>now, given that this has been running for years?  I would only expect to
>see something like this in new code that is still being developed.

Lustre is still being developed, so it is useful to be able to enable this
debugging to catch any new problems that are introduced.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


