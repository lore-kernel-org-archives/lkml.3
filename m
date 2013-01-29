Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3A2HQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:16:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:34264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab3A2HQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:16:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,557,1355126400"; 
   d="scan'208";a="254003909"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: [Ilw] iwlwifi/iwldvm soft lockup with 3.8.0-rc5 (was: almost
 unusable on 3.8.0-rc5)
Thread-Topic: [Ilw] iwlwifi/iwldvm soft lockup with 3.8.0-rc5 (was: almost
 unusable on 3.8.0-rc5)
Thread-Index: AQHN/ar8A9PKTNcEVEuBvT+o3zOfR5hf5A0g
Date: Tue, 29 Jan 2013 07:16:34 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301925D7A@HASMSX103.ger.corp.intel.com>
References: <20130128225657.GA17533@kashmir>
In-Reply-To: <20130128225657.GA17533@kashmir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 	Hello all,
> 
> Oh the irony, I was just starting an email saying wifi is almost unusable for me
> with 3.8 and my machine (a thinkpad t530) completely froze while typing it...
> 
> I was going to say I'm getting a lot of:
> iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
> 

Please try this one:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=c3e5d7181afb66657393066bccce0956fab09ab3

as you can see, it is in mainline already.
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

