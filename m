Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaJ0GOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 02:14:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:23810 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaJ0GOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 02:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,793,1406617200"; 
   d="scan'208";a="596708063"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 07/11] iwlwifi: dvm: Fix probable mask then right shift
 defect
Thread-Topic: [PATCH 07/11] iwlwifi: dvm: Fix probable mask then right shift
 defect
Thread-Index: AQHP8aaWhm+RpgRvEUej0xCtk4mSrZxDdyZg
Date: Mon, 27 Oct 2014 06:14:29 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B556ABD@hasmsx107.ger.corp.intel.com>
References: <cover.1414387334.git.joe@perches.com>
 <83c3bfdd0c8f21fbbcbd9ebb5746a8fb04494fac.1414387334.git.joe@perches.com>
In-Reply-To: <83c3bfdd0c8f21fbbcbd9ebb5746a8fb04494fac.1414387334.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> Add parentheses around the mask.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Applied - thanks.
