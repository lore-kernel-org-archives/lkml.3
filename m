Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaLDFgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 00:36:46 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44541 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaLDFgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 00:36:45 -0500
MIME-Version: 1.0
X-Originating-IP: [2601:6:6b00:f9::a66]
In-Reply-To: <1417572235-8197-7-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1417572235-8197-1-git-send-email-sukadev@linux.vnet.ibm.com>
	<1417572235-8197-7-git-send-email-sukadev@linux.vnet.ibm.com>
Date: Thu, 4 Dec 2014 00:36:44 -0500
Message-ID: <CAPoQQ-1mYANQxt0Ld7Qf19fbEaOR0hpcWPg4qrxGAshcgaBKLA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] powerpc/perf/hv-24x7: Document sysfs event
 description entries
From: Cody P Schafer <dev@codyps.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, hbabu@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7 b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
> index 32f3f5f..cf70084 100644
> --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
> @@ -21,3 +21,25 @@ Contact:     Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
> +Contact:       Cody P Schafer <cody@linux.vnet.ibm.com>

Probably want someone else to be the contact here.
