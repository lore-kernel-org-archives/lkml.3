Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3KHIqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:46:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab3KHIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:46:39 -0500
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, matthew.garrett@nebula.com, jlee@suse.com
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter to efi_storage_paranoia
In-reply-to: <527C9B5C.6040509@nod.at>
Date: Fri, 08 Nov 2013 16:46:19 +0800
Message-ID: <8761s3waas.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard@nod.at writes:

> Am 08.11.2013 08:33, schrieb Yasuaki Ishimatsu:
>> 
>> According to above works, efi_no_storage_paranoia parameter was prepared
>> for sane UEFI which can do gc and fulfills spec. But why need a system
>> with a sane UEFI set the parameter? It is wrong. A system with a broken
>> UEFI should set the parameter.
>
> And how does one know that his UEFI is broken?
> "Oh my board is briked because I wrote too much into a variable, maybe setting
> efi_storage_paranoia would have saved me. Let's try with the next board..." ;)
>
Agreed. It's hard for people to fix their briked motherboard. At least
it's hard for someone who is the first time meet this issue like me. :-(
and IMO, at least 51% of uefi firmwares on the world is buggy... ;)
However, if we simply make all buggy firmware become a brick, the
vendors will more careful in their next generation of products... But
it's painful for everyone, both customers and vendors.
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best,
Madper Xie.
