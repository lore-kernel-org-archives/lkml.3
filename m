Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaLAMyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:54:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbaLAMyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:54:16 -0500
Message-ID: <547C64F3.9050005@suse.com>
Date: Mon, 01 Dec 2014 13:54:11 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Subject: Re: [PATCH V4 00/10] xen: Switch to virtual mapped linear p2m list
References: <1417172039-8627-1-git-send-email-jgross@suse.com> <547C51AD.8070904@citrix.com>
In-Reply-To: <547C51AD.8070904@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 12:31 PM, David Vrabel wrote:
> On 28/11/14 10:53, Juergen Gross wrote:
>> Paravirtualized kernels running on Xen use a three level tree for
>> translation of guest specific physical addresses to machine global
>> addresses. This p2m tree is used for construction of page table
>> entries, so the p2m tree walk is performance critical.
>>
>> By using a linear virtual mapped p2m list accesses to p2m elements
>> can be sped up while even simplifying code. To achieve this goal
>> some p2m related initializations have to be performed later in the
>> boot process, as the final p2m list can be set up only after basic
>> memory management functions are available.
>
> What are the results of the testing I asked for?

You asked for those replying to the patch introducing the linear
mapping. So I added the description of the tested scenarios in the
patch description of that patch.

> If Konrad or Boris are happy with this series I think it can go into 3.19.

Great, thanks!


Juergen

