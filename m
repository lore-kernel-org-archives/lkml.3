Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3JUOh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:37:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41099 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3JUOh2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Mon, 21 Oct 2013 10:37:28 -0400
Message-Id: <5265584102000078000FC771@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 21 Oct 2013 15:37:21 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <ian.campbell@citrix.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <grub-devel@gnu.org>,
        <david.woodhouse@intel.com>, <richard.l.maliszewski@intel.com>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, "Daniel Kiper" <daniel.kiper@oracle.com>,
        <pjones@redhat.com>, <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <52654A0602000078000FC611@nat28.tlf.novell.com>
 <20131021142347.GB4211@phenom.dumpdata.com>
In-Reply-To: <20131021142347.GB4211@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.10.13 at 16:23, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Mon, Oct 21, 2013 at 02:36:38PM +0100, Jan Beulich wrote:
>> >>> On 21.10.13 at 14:57, Daniel Kiper <daniel.kiper@oracle.com> wrote:
>> 
>> (Looking at the Cc list it's quite interesting that you copied a
>> whole lot of people, but not me as the maintainer of the EFI
>> bits in Xen.)
> 
> I see this:
> 
> From: Daniel Kiper <daniel.kiper@oracle.com>
> To: boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
>         ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
> 
> 
> You are on the 'To' instead of the 'CC'. That should make the email
> arrive at your mailbox much quicker than through the mailing list?

Indeed - I was clearly looking at the wrong place. I'm very sorry.

>> > What do you think about that?
>> > Any comments, suggestions, objections?
>> 
>> The complications here make it pretty clear to me that the
>> GrUB2-less solution (or, if GruB2 absolutely has to be involved,
>> its chain loading capability) I have been advocating continues
>> to be the better (and, as said before, conceptually correct)
>> model.
> 
> However my understanding is that the general distro approach is
> to use GRUB2 and I think we want to follow the mainstream on this.
> Which means using GRUB2 and making sense of the myrid of patches
> that each distro has.

As does ours - and we simply use the chain loading mechanism as
I'm told (and as I suggested - I'm only occasionally involved in the
secure boot stuff).

Jan


