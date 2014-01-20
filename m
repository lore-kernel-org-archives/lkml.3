Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaATCBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 21:01:06 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:57594 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaATCA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 21:00:58 -0500
Message-ID: <52DC8350.4060704@linux.vnet.ibm.com>
Date: Mon, 20 Jan 2014 10:00:48 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, KVM <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: make KVM_MMU_AUDIT help text more readable
References: <52D9E0BE.2070500@infradead.org>
In-Reply-To: <52D9E0BE.2070500@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012002-5816-0000-0000-00000BD9180F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2014 10:02 AM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Make KVM_MMU_AUDIT kconfig help text readable and collapse
> two spaces between words down to one space.
> 

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

