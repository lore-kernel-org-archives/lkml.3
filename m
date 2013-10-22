Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3JVHQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:16:26 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41688 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3JVHQZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Tue, 22 Oct 2013 03:16:25 -0400
Message-Id: <5266426402000078000FC991@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 22 Oct 2013 08:16:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <ian.campbell@citrix.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <grub-devel@gnu.org>,
        <david.woodhouse@intel.com>, <richard.l.maliszewski@intel.com>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>, <pjones@redhat.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <52654A0602000078000FC611@nat28.tlf.novell.com>
 <20131021142347.GB4211@phenom.dumpdata.com>
 <5265584102000078000FC771@nat28.tlf.novell.com>
 <20131021184643.GC3626@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131021184643.GC3626@debian70-amd64.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.10.13 at 20:46, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> On Mon, Oct 21, 2013 at 03:37:21PM +0100, Jan Beulich wrote:
>> >>> On 21.10.13 at 16:23, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > However my understanding is that the general distro approach is
>> > to use GRUB2 and I think we want to follow the mainstream on this.
>> > Which means using GRUB2 and making sense of the myrid of patches
>> > that each distro has.
>>
>> As does ours - and we simply use the chain loading mechanism as
>> I'm told (and as I suggested - I'm only occasionally involved in the
>> secure boot stuff).
> 
> Do you think about GRUB2 chainloader command?

Sure.

Jan

