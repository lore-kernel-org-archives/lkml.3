Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936AbaFCULY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:11:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080AbaFCULU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:11:20 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Emulate VMXON region correctly
References: <1399357158-8305-1-git-send-email-bsd@redhat.com>
	<5369156F.1070104@redhat.com>
Date: Tue, 03 Jun 2014 16:11:10 -0400
In-Reply-To: <5369156F.1070104@redhat.com> (Paolo Bonzini's message of "Tue,
	06 May 2014 19:01:35 +0200")
Message-ID: <jpgoay9eotd.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 06/05/2014 08:19, Bandan Das ha scritto:
>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=54521
>>
>> The vmxon region is unused by nvmx, but adding these checks
>> are probably harmless and may detect buggy L1 hypervisors in
>> the future!
>
> Applied to kvm/queue, unit test patches are welcome (hint, hint!).

Jan and Paolo,

Ok, I thought a little bit about this and I am wondering what 
kind of tests we could have here. All the changes are pure 
checks and no data is returned back to the guest. The
vmxon code in kvm-unit-tests already does the right thing i.e
sets the revision identifier, allocs a page for the region etc

> Paolo
