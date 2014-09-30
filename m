Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaI3O1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:27:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:13457 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbaI3O1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:27:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,626,1406617200"; 
   d="scan'208";a="481008267"
Message-ID: <542ABDE7.7090808@intel.com>
Date: Tue, 30 Sep 2014 07:27:51 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dvlasenk@redhat.com,
        prarit@redhat.com, lwoodman@redhat.com, hannsj_uhl@de.ibm.com,
        torvalds@linux-foundation.org
Subject: Re: [RESEND PATCH 2/4] x86: add phys addr validity check for /dev/mem
 mmap
References: <1411990382-11902-1-git-send-email-fhrbata@redhat.com> <1411990382-11902-3-git-send-email-fhrbata@redhat.com> <alpine.DEB.2.02.1409292211560.22082@ionos.tec.linutronix.de> <20140930124121.GB3073@localhost.localdomain>
In-Reply-To: <20140930124121.GB3073@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 05:41 AM, Frantisek Hrbata wrote:
> Does it make sense to replace "count" with "size" so it's consistent with the
> rest or do you prefer "nr_bytes" or as Dave proposed "len_bytes"?

I don't care what it is as long as it has a unit in it.
