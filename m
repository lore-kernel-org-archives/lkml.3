Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3H2Nyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:54:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:10036 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab3H2Nyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:54:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,983,1367996400"; 
   d="scan'208";a="393958504"
Message-ID: <521F5297.4070906@linux.intel.com>
Date: Thu, 29 Aug 2013 06:54:31 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: ebiederm@xmission.com, vgoyal@redhat.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        jingbai.ma@hp.com
Subject: Re: [PATCH 0/2] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
In-Reply-To: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 02:27 AM, HATAYAMA Daisuke wrote:
> This is the patch series to address the issue that kdump 2nd kernel
> now fails to wake up multiple CPUs.

Please explain the "now" in the above sentence.  Is this a regression?
If so, what is its impact?  Is this something that needs to go into 3.11
as a post-rc7 change, which means it better be hyper-critical?

	-hpa


