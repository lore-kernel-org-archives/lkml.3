Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3J1Ssx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:48:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39888 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab3J1Ssv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:48:51 -0400
Date: Mon, 28 Oct 2013 11:42:45 -0700 (PDT)
From: Seth Goldberg <seth.goldberg@oracle.com>
X-X-Sender: sethg@bergsoft
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: "=?ISO-8859-7?Q?Vladimir_'=F6-coder=2Fphcoder'_Serbinenko?=" 
	<phcoder@gmail.com>,
        seth.goldberg@oracle.com,
        The development of GNU GRUB <grub-devel@gnu.org>,
        Daniel Kiper <daniel.kiper@oracle.com>, boris.ostrovsky@oracle.com,
        david.woodhouse@intel.com, ian.campbell@citrix.com, jbeulich@suse.com,
        keir@xen.org, pjones@redhat.com, richard.l.maliszewski@intel.com,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
In-Reply-To: <20131028162603.GA4716@phenom.dumpdata.com>
Message-ID: <alpine.GSO.2.00.1310281142190.2162@oretfbsg>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <526599A8.9090501@gmail.com> <52663D54.2020800@gmail.com> <20131028162603.GA4716@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-435944768-1382985767=:2162"
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-435944768-1382985767=:2162
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

Quoting Konrad Rzeszutek Wilk, who wrote the following on Mon, 28 Oct 2013:

> On Tue, Oct 22, 2013 at 10:54:44AM +0200, Vladimir '=CF=86-coder/phcoder'=
 Serbinenko wrote:
>> On 21.10.2013 23:16, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:
>>> Mail is big, I think I got your essential points but I didn't read it w=
hole.
>>> On 21.10.2013 14:57, Daniel Kiper wrote:
>>>> Hi,
>>>>
>>>> During work on multiboot2 protocol support for Xen it was discovered
>>>> that memory map passed via relevant tag could not represent wide range
>>>> of memory types available on EFI platforms. Additionally, GRUB2
>>>> implementation calls ExitBootServices() on them just before jumping
>>>> into loaded image. In this situation loaded system could not clearly
>>>> identify reserved memory regions, EFI runtime services regions and oth=
ers.
>>>>
>>> Will a multiboot2 tag with whole EFI memory map solve your problem?
>> I added such a tag in documentation and wrote a patch for it (attached).
>> Awaiting for someone to test it to commit
>
> Great! I think from Xen perspective we first need to have Xen be able
> to understand multiboot2 - that is something Daniel had been working on.
> I will let Daniel talk more about it.
>
> Seth, would you have any time to test the patch against Solaris to
> make sure it works?

   I'd love to, yes.  I'm just a bit short on time this week.

  Thanks,
  --S
---559023410-435944768-1382985767=:2162--
