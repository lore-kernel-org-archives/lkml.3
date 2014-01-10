Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbaAJTk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:40:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaAJTkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:40:24 -0500
Message-ID: <52D04367.1070107@redhat.com>
Date: Fri, 10 Jan 2014 14:00:55 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        kosaki.motohiro@gmail.com, dyoung@redhat.com,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] x86, e820 disable ACPI Memory Hotplug if memory mapping
 is specified by user
References: <1389379579-18614-1-git-send-email-prarit@redhat.com> <1389379579-18614-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1389379579-18614-3-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/10/2014 01:46 PM, Prarit Bhargava wrote:
> kdump uses memmap=exactmap and mem=X values to configure the memory
> mapping for the kdump kernel.  If memory is hotadded during the boot of
> the kdump kernel it is possible that the page tables for the new memory
> cause the kdump kernel to run out of memory.
> 
> Since the user has specified a specific mapping ACPI Memory Hotplug should be
> disabled in this case.
> 

Noticed a bug in this.  Will repost a new version shortly.

P.
