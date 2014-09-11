Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaIKJmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:42:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:57263 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753366AbaIKJmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:42:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35807207"
Message-ID: <54116EC2.8020802@cn.fujitsu.com>
Date: Thu, 11 Sep 2014 17:43:30 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, <gleb@kernel.org>,
        <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v5 7/7] kvm, mem-hotplug: Unpin and remove nested_vmx->apic_access_page.
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-8-git-send-email-tangchen@cn.fujitsu.com> <54116C6F.8030300@redhat.com>
In-Reply-To: <54116C6F.8030300@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/11/2014 05:33 PM, Paolo Bonzini wrote:
> This patch is not against the latest KVM tree.  The call to
> nested_get_page is now in nested_get_vmcs12_pages, and you have to
> handle virtual_apic_page in a similar manner.
Hi Paolo,

Thanks for the reviewing.

This patch-set is against Linux v3.17-rc4.
Will make it against the latest KVM tree, and resend a patch set 
following you comments.

Thanks.
