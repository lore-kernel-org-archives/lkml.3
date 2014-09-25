Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaIYNnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:43:35 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:54872 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaIYNnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:43:33 -0400
Message-ID: <54241BFA.5000503@redhat.com>
Date: Thu, 25 Sep 2014 15:43:22 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/8] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
References: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com> <54227EB4.7070608@redhat.com> <5423D015.6090107@cn.fujitsu.com>
In-Reply-To: <5423D015.6090107@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/09/2014 10:19, Tang Chen ha scritto:
> Hi Paolo,
> 
> I'd like to help to test the patches.
> Would you please tell me what is the best way to test this patch-set ?

How did _you_ test the patches?...

> I think ept page is being used by regular guest.
> Is adding "-cpu xxx,-x2apic option" able to make sure guest is using
> apic page ?

Yes.

Paolo
