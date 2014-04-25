Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaDYQYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:24:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:11799 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbaDYQYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="519801389"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: how to include already compiled object files to kernel
Thread-Topic: how to include already compiled object files to kernel
Thread-Index: Ac9gojb8jtX0K20pQFGL2vOl15VYgg==
Date: Fri, 25 Apr 2014 16:24:20 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD574BFA6D@BGSMSX104.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI All,

I have received few kernel library .o (object files) from third party and I am planning to include in our kernel tree. As the library contains some proprietary algorithms  the sources are not shared.

How can I include this library .o files to my kernel and if this kernel is release to customers will there be any license issues? Third party says the sources are under GPL.

Thanks,
Ram
