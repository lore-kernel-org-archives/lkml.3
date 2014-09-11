Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaIKJTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:19:41 -0400
Received: from david.siemens.de ([192.35.17.14]:41113 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaIKJTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:19:39 -0400
Message-ID: <5411691D.5060103@siemens.com>
Date: Thu, 11 Sep 2014 11:19:25 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>,
        Chris J Arges <chris.j.arges@canonical.com>, kvm@vger.kernel.org
CC: Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: ioapic: add check for RTC_GSI
References: <1410368033-23628-1-git-send-email-chris.j.arges@canonical.com> <54113AB2.3020801@siemens.com> <54116699.8080303@redhat.com>
In-Reply-To: <54116699.8080303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-11 11:08, Paolo Bonzini wrote:
> Il 11/09/2014 08:01, Jan Kiszka ha scritto:
>> That issue is limited to the dead ia64 architecture, no other builds
>> ioapic.c (besides x86, of course). Maybe finally remove KVM support for
>> that arch instead of bloating otherwise correct code?
> 
> Yes, we should.  I've just been too busy to do it.

As I enjoy creating large negative diffs :), I would almost do it - if I
had a test environment for IA64...

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
