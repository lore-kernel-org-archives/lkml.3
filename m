Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3JOQxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:53:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:46994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3JOQxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:53:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,500,1378882800"; 
   d="scan'208";a="417233096"
Message-ID: <525D7315.8080005@linux.intel.com>
Date: Tue, 15 Oct 2013 09:53:41 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Roel Kluin <roel.kluin@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jump_label: unlikely(x) > 0
References: <alpine.DEB.2.02.1310112241220.11060@Z> <20131011135704.6fd455e2387a37f1972a4e0f@linux-foundation.org>
In-Reply-To: <20131011135704.6fd455e2387a37f1972a4e0f@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 01:57 PM, Andrew Morton wrote:
> 
> I'm sure this was intended instead ;) The patch doesn't seem to make
> any difference in code generation with my gcc.
> 

Which is odd, because doesn't unlikely() booleanize?

	-hpa

