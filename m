Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaAQBPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:15:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaAQBPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:15:43 -0500
Message-ID: <52D8841F.9030709@redhat.com>
Date: Thu, 16 Jan 2014 20:15:11 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Len Brown <lenb@kernel.org>, kosaki.motohiro@gmail.com,
        dyoung@redhat.com, rientjes@google.com, linux-acpi@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH] acpi memory hotplug, add parameter to disable memory
 hotplug [v5]
References: <1389822660.1792.349.camel@misato.fc.hp.com> <1389886551-32647-1-git-send-email-prarit@redhat.com> <2048690.9OePJDLjDY@vostro.rjw.lan>
In-Reply-To: <2048690.9OePJDLjDY@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/16/2014 08:26 PM, Rafael J. Wysocki wrote:
> On Thursday, January 16, 2014 10:35:51 AM Prarit Bhargava wrote:
>> When booting a kdump kernel on a system that has specific memory hotplug
>> regions the boot will fail with warnings like:
> 
> The timestamps are still present, sigh.
> 
> OK, please see
> 
> http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=bleeding-edge&id=00159a2013269bc0a617de885e4b921349192bd0
> 
> and tell me if it looks good to you.
> 

Looks good to me.

P.
