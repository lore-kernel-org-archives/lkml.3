Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3BVIra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:47:30 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:42630 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3BVIr1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Fri, 22 Feb 2013 03:47:27 -0500
Message-Id: <51273EE602000078000C03DC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 22 Feb 2013 08:48:22 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>
Cc: "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir(Xen.org)" <keir@xen.org>, "Tim (Xen.org)" <tim@xen.org>
Subject: Re: [PATCH XEN] xen: event channel arrays are xen_ulong_t and
 not unsigned long
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
 <1361285363-27133-1-git-send-email-ian.campbell@citrix.com>
 <1361466961.26546.85.camel@zakaz.uk.xensource.com>
 <5127366502000078000C0380@nat28.tlf.novell.com>
 <1361521720.26546.93.camel@zakaz.uk.xensource.com>
In-Reply-To: <1361521720.26546.93.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.02.13 at 09:28, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> On Fri, 2013-02-22 at 08:12 +0000, Jan Beulich wrote:
>> >>> On 21.02.13 at 18:16, Ian Campbell <Ian.Campbell@citrix.com> wrote:
>> > On Tue, 2013-02-19 at 14:49 +0000, Ian Campbell wrote:
>> >> On ARM we want these to be the same size on 32- and 64-bit.
>> >> 
>> >> This is an ABI change on ARM. X86 does not change.
>> >> 
>> >> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> >> Cc: Jan Beulich <JBeulich@suse.com>
>> >> Cc: Keir (Xen.org) <keir@xen.org>
>> > 
>> > Are you guys (un)happy with this change from the Xen & x86 side?
>> 
>> I don't see any problem with it.
> 
> I'll take this as an Acked-by if that's ok with you.

Well, I specifically didn't say "ack": I don't really mind the change,
but I'm also not eager see it go in. Not seeing a problem with it
doesn't really mean there's none lurking - type changes in public
interfaces are always an at least slightly risky business.

Jan

