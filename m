Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaBRTg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:36:57 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:58556 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaBRTgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:36:54 -0500
MIME-Version: 1.0
In-Reply-To: <53021F47.5050702@gmail.com>
References: <52FDD955.4000701@gmail.com>
	<20140214091639.GB1782@redhat.com>
	<52FE5E74.6000509@gmail.com>
	<53021F47.5050702@gmail.com>
Date: Tue, 18 Feb 2014 11:36:53 -0800
X-Google-Sender-Auth: 1aUOm9EzW51R31diN5TT23aADK0
Message-ID: <CAA9_cmd_AcHRUqqPziyd4bbLGcDWGJdneWd_Wk+KEQynhuHj+w@mail.gmail.com>
Subject: Re: [dma-debug.c - DMA-API] exceeded overlapping ... & sym53c8xx ...
 tries to free DMA ...
From: Dan Williams <dan.j.williams@intel.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Joerg Roedel <joro@8bytes.org>, Tejun Heo <tj@kernel.org>,
        Gerard Roudier <groudier@club-internet.fr>,
        Alan Stern <stern@rowland.harvard.edu>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 6:40 AM, poma <pomidorabelisima@gmail.com> wrote:
> On 14.02.2014 19:20, poma wrote:
>> On 14.02.2014 10:16, Stanislaw Gruszka wrote:
>>> On Fri, Feb 14, 2014 at 09:52:37AM +0100, poma wrote:
>>>>
>>>> Ahoy!
>>>>
>>>> Perhaps this is already solved, but I made the effort to test & record
>>>> all of this, therefore here you are. :)
>>>>
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1062833
>>>
>>> There is patch posted for this problem
>>> http://marc.info/?l=linux-kernel&m=139233546223338&w=2
>>> It is under review currently, if there will be no complains it will be
>>> applied.
>>>
>>> Stanislaw
>>>
>>
>> Thanks!
>> I have a few questions but the weekend begins, so we'll leave it for
>> later. :)
>> See ya!
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1062833
>
> IDE disk - ata_piix - dmesg - OK
> https://bugzilla.redhat.com/attachment.cgi?id=864085
>
> SATA disk - ahci - dmesg - OK
> https://bugzilla.redhat.com/attachment.cgi?id=864086
>
> SCSI disk - sym53c8xx - dmesg - OK
> https://bugzilla.redhat.com/attachment.cgi?id=864087
>
> VirtIO SCSI disk - virtio_scsi - dmesg - OK
> https://bugzilla.redhat.com/attachment.cgi?id=864088
>
> USB disk - usb_storage - dmesg - OK
> https://bugzilla.redhat.com/attachment.cgi?id=864089
>
> Test media - 'boot-fix-dma-debug-overlap-v2.iso',
> http://goo.gl/UJSfVn
> sha256sum:
> 6d6b36fdcb0a0ff662ff6a27048d6d5f35ac211c34439f75bba1d524b3507e82
> boot-fix-dma-debug-overlap-v2.iso
>
> Contains 'kernel-3.14.0-0.rc2.git4.1.fc21.x86_64'
> based on Rawhide 'kernel-3.14.0-0.rc2.git4.1.fc21'
> http://koji.fedoraproject.org/koji/buildinfo?buildID=498404
> with the addition of Dan's 'fix-dma-debug-overlap-v2.patch'
> "Fix dma debug v2: account for cachelines and read-only mappings in
> overlap tracking"
> http://marc.info/?l=linux-netdev&m=139233546723342&q=raw
>
>
> All tests are PASSED.
>
>        _
>       ( \
>        \ \
>    ____)  \
>   (___)    ------
>  (___)
>  (___)
>   (__)----------------
>
>
>
> poma

Thanks for the in-depth regression test and report.  Much appreciated!

--
Dan
