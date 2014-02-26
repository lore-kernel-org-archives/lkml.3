Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaBZOxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:53:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaBZOxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:53:16 -0500
Date: Wed, 26 Feb 2014 09:52:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
Message-ID: <20140226145246.GA23022@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
 <530B989B.8010507@zytor.com>
 <20140225164342.GC2701@redhat.com>
 <530CCB0E.3060009@zytor.com>
 <20140225182002.GD2701@redhat.com>
 <530D068E.4040700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530D068E.4040700@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 01:09:34PM -0800, H. Peter Anvin wrote:
> On 02/25/2014 10:20 AM, Vivek Goyal wrote:
> > 
> > Please let me know if you don't like the idea and you still think there
> > should be a shared implementation between arch/x86/boot/ and
> > arch/x86/purgatory/.
> > 
> 
> That is what I would *prefer*.  There are some other string functions in
> arch/x86/boot/string.c which also ought to be sharable (and are in
> places already.)
> 

Ok, I will look into it. Possibly move optimized 32bit and 64bit version of
memcpy in arch/x86/boot/string.c and include it in purgaotry files.

Or we could define new C version of routines in boot/string.c and leave
optimized versions where they are.

Thanks
Vivek
