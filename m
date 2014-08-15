Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaHOKR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 06:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbaHOKRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 06:17:55 -0400
Date: Fri, 15 Aug 2014 12:17:31 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com
Subject: Re: [PATCH 1/1] x86: add phys addr validity check for /dev/mem mmap
Message-ID: <20140815101731.GC3339@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1408025927-16826-1-git-send-email-fhrbata@redhat.com>
 <1408025927-16826-2-git-send-email-fhrbata@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408025927-16826-2-git-send-email-fhrbata@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

self-nack

As pointed by Dave Hansen, the check is just wrong. I will post V2.

Many thanks Dave!

-- 
Frantisek Hrbata
