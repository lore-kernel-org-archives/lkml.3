Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaBQOkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:40:19 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:62205 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbaBQOkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:40:17 -0500
Message-ID: <53021F47.5050702@gmail.com>
Date: Mon, 17 Feb 2014 15:40:07 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Joerg Roedel <joro@8bytes.org>,
        Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        Gerard Roudier <groudier@club-internet.fr>,
        Alan Stern <stern@rowland.harvard.edu>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: =?UTF-8?B?UmU6IFtkbWEtZGVidWcuYyAtIERNQS1BUEldIGV4Y2VlZGVkIG92ZXI=?=
 =?UTF-8?B?bGFwcGluZyDigKYgJiBzeW01M2M4eHgg4oCmIHRyaWVzIHRvIGZyZWUgRE1BIOKApg==?=
References: <52FDD955.4000701@gmail.com> <20140214091639.GB1782@redhat.com> <52FE5E74.6000509@gmail.com>
In-Reply-To: <52FE5E74.6000509@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.02.2014 19:20, poma wrote:
> On 14.02.2014 10:16, Stanislaw Gruszka wrote:
>> On Fri, Feb 14, 2014 at 09:52:37AM +0100, poma wrote:
>>>
>>> Ahoy!
>>>
>>> Perhaps this is already solved, but I made ​​the effort to test & record
>>> all of this, therefore here you are. :)
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=1062833
>>
>> There is patch posted for this problem
>> http://marc.info/?l=linux-kernel&m=139233546223338&w=2
>> It is under review currently, if there will be no complains it will be
>> applied.
>>
>> Stanislaw
>>
> 
> Thanks!
> I have a few questions but the weekend begins, so we'll leave it for
> later. :)
> See ya!

https://bugzilla.redhat.com/show_bug.cgi?id=1062833

IDE disk - ata_piix - dmesg - OK
https://bugzilla.redhat.com/attachment.cgi?id=864085

SATA disk - ahci - dmesg - OK
https://bugzilla.redhat.com/attachment.cgi?id=864086

SCSI disk - sym53c8xx - dmesg - OK
https://bugzilla.redhat.com/attachment.cgi?id=864087

VirtIO SCSI disk - virtio_scsi - dmesg - OK
https://bugzilla.redhat.com/attachment.cgi?id=864088

USB disk - usb_storage - dmesg - OK
https://bugzilla.redhat.com/attachment.cgi?id=864089

Test media - 'boot-fix-dma-debug-overlap-v2.iso',
http://goo.gl/UJSfVn
sha256sum:
6d6b36fdcb0a0ff662ff6a27048d6d5f35ac211c34439f75bba1d524b3507e82
boot-fix-dma-debug-overlap-v2.iso

Contains 'kernel-3.14.0-0.rc2.git4.1.fc21.x86_64'
based on Rawhide 'kernel-3.14.0-0.rc2.git4.1.fc21'
http://koji.fedoraproject.org/koji/buildinfo?buildID=498404
with the addition of Dan's 'fix-dma-debug-overlap-v2.patch'
"Fix dma debug v2: account for cachelines and read-only mappings in
overlap tracking"
http://marc.info/?l=linux-netdev&m=139233546723342&q=raw


All tests are PASSED.

       _
      ( \
       \ \
   ____)  \
  (___)    ―――
 (___)
 (___)
  (__)――――――――



poma


