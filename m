Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaI3VDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:03:14 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52109 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaI3VDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:03:13 -0400
MIME-Version: 1.0
X-Originating-IP: [72.74.84.52]
In-Reply-To: <1411586844-21381-11-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
	<1411586844-21381-11-git-send-email-sukadev@linux.vnet.ibm.com>
Date: Tue, 30 Sep 2014 17:03:10 -0400
Message-ID: <CAPoQQ-2YM-2n0ATrzCZqaF2e2a4rh9tus=JayRoVed2DyX=-EQ@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] powerpc/perf/hv-24x7: Document sysfs event
 description entries
From: Cody P Schafer <dev@codyps.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +What:          /sys/bus/event_source/devices/hv_24x7/event_descs/<event-name>
> +Date:          February 2014
> +Contact:       Cody P Schafer <cody@linux.vnet.ibm.com>

May want to change this contact email to an address that still works
(perhaps the ppc devel list?)
