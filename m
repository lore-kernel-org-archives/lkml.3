Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3ISWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:25:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:10875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3ISWZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:25:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,940,1371106800"; 
   d="scan'208";a="380810474"
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: Thomas Meyer <thomas@m3y3r.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] NVMe: Cocci spatch "kzalloc-simple"
Thread-Topic: [PATCH 1/2] NVMe: Cocci spatch "kzalloc-simple"
Thread-Index: AQHOtYPunnl54iCbH0WF7vDJ8vtZxpnNs/6A
Date: Thu, 19 Sep 2013 22:25:24 +0000
Message-ID: <CE60D5BF.F105%vishal.l.verma@intel.com>
In-Reply-To: <1379604510863-2133994021-1-diffsplit-thomas@m3y3r.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.7.130812
x-originating-ip: [10.22.226.39]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <57B172942144744097E0EBD862511940@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/13 3:45 PM, "Thomas Meyer" <thomas@m3y3r.de> wrote:

>Use kzalloc rather than kmalloc followed by memset with 0.
>Found by coccinelle spatch "api/alloc/kzalloc-simple.cocci"
>
>Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
>---

Thomas,

This has already been applied to Matthew's tree:
http://git.infradead.org/users/willy/linux-nvme.git/commitdiff/03ea83e9a37e
41d436f8348e6eee3d8281bfff3a


-Vishal

