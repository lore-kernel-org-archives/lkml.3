Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaBXQlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:41:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbaBXQlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:41:06 -0500
Message-ID: <530B7619.2050805@redhat.com>
Date: Mon, 24 Feb 2014 17:40:57 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>
CC: "'gleb@redhat.com'" <gleb@redhat.com>, "'hpa@zytor.com'" <hpa@zytor.com>
Subject: Re: [PATCH v5 3/3] KVM: x86: Enable Intel MPX for guest
References: <DE8DF0795D48FD4CA783C40EC82923350150E43C@SHSMSX101.ccr.corp.intel.com> <530B2949.4030000@redhat.com> <DE8DF0795D48FD4CA783C40EC82923350150F2D0@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350150F2D0@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/02/2014 16:37, Liu, Jinsong ha scritto:
> So patch v5 would be applied except you will remove the incorrect
> hunk, and you will send a patch strengthenning guest_supported_xcr0?

Yes.

Paolo
