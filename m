Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3JWI3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:29:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3JWI3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:29:00 -0400
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <526599A8.9090501@gmail.com> <52663D54.2020800@gmail.com> <20131023070528.GQ3626@debian70-amd64.local.net-space.pl>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20131023070528.GQ3626@debian70-amd64.local.net-space.pl>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-Id: <830D780E-6D6A-4398-B736-7E1D87C40EF7@oracle.com>
Cc: "=?utf-8?Q?Vladimir_'=CF=86-coder/phcoder'_Serbinenko?=" 
	<phcoder@gmail.com>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        "keir@xen.org" <keir@xen.org>,
        "david.woodhouse@intel.com" <david.woodhouse@intel.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "richard.l.maliszewski@intel.com" <richard.l.maliszewski@intel.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
X-Mailer: iPad Mail (11B511)
From: Seth Goldberg <seth.goldberg@oracle.com>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Date: Wed, 23 Oct 2013 01:28:40 -0700
To: The development of GNU GRUB <grub-devel@gnu.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Oct 23, 2013, at 12:05 AM, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> 
>> On Tue, Oct 22, 2013 at 10:54:44AM +0200, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
>>> On 21.10.2013 23:16, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
>>> Mail is big, I think I got your essential points but I didn't read it whole.
>>>> On 21.10.2013 14:57, Daniel Kiper wrote:
>>>> Hi,
>>>> 
>>>> During work on multiboot2 protocol support for Xen it was discovered
>>>> that memory map passed via relevant tag could not represent wide range
>>>> of memory types available on EFI platforms. Additionally, GRUB2
>>>> implementation calls ExitBootServices() on them just before jumping
>>>> into loaded image. In this situation loaded system could not clearly
>>>> identify reserved memory regions, EFI runtime services regions and others.
>>> Will a multiboot2 tag with whole EFI memory map solve your problem?
>> I added such a tag in documentation and wrote a patch for it (attached).
> 
> Thanks. Could you send me a pointer to current multiboot2 protocol docs?
> 
>> Awaiting for someone to test it to commit
> 
> On first sight it looks quite nice. However, as I know Solaris guys
> prepared similar solution. I am not sure it was discussed with GRUB2
> guys. However, I think that it is worth coordinating both works and
> do not break existing solution if it is possible.
> 
> I will try to get more details about Solaris implementation.

  It's compatible.  Vladimir based this change on the changes we made; we just need to test to verify.

  --S


> 
> Daniel
> 
> _______________________________________________
> Grub-devel mailing list
> Grub-devel@gnu.org
> https://lists.gnu.org/mailman/listinfo/grub-devel
