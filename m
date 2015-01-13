Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbbAMQ3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:29:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbbAMQ3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:29:43 -0500
Message-ID: <54B540F7.3020603@redhat.com>
Date: Tue, 13 Jan 2015 10:59:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
CC: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: Re: [RFC PATCH 01/11] x86,fpu: document the data structures a little
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-2-git-send-email-riel@redhat.com> <54B44210.4090608@intel.com>
In-Reply-To: <54B44210.4090608@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/12/2015 04:52 PM, Dave Hansen wrote:
> On 01/11/2015 01:46 PM, riel@redhat.com wrote:
>> +/* + * The FPU state used depends on the capabilities of the
>> hardware; the + * registers used for vector instructions on newer
>> hardware are included + * in the FPU state. + */ union
>> thread_xstate {
> 
> Tiny nit, if you happen to revise this set at some point...
> 
> While you probably don't need/want to have an exhaustive list of 
> everything that gets saved in there, we should probably still
> mention that it's a lot more than just vector instructions.
> 
> I'd say:
> 
> The FPU state used depends on the capabilities of the hardware.
> This state increasingly contains things not related to the FPU
> itself, like registers used for vector instructions.
> 
I like it.  I replaced my comment with your improved one.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtUD3AAoJEM553pKExN6D9vAIAJg02XYwxLoJYWAEDOn7SxWc
Y18RGzaE8YIM0GLevMdOAu5EJ9IitZzHG/I7dBPr0j7ATwOZrjfg6WsS02Eonk8P
yLS/NQFUWb4bkjPYJNdyrM76BLr2diEHdS2aw97sBXiVrM2SVVu0o45GU8pc241X
WGPV4G3TlyTgJLxAn0+kbvBF0PZhEEHhTP4QPkIjqht8/q9DKOC7dPaQA8aUYYVy
ISXSsg7gHCZ9KcBGmgx90kFLKDwLC6H8lV8MCe7tZDyof/mvpuNcZY843YV/uZNK
/DeMrSbdVJgyau73HZXt8Fm42G56PiA79/kluuQc7rXBk4tcwu/t/DxX0wbD6WE=
=3Vvs
-----END PGP SIGNATURE-----
