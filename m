Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3HPBhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 21:37:33 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36400 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3HPBhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 21:37:32 -0400
Message-ID: <1376617039.2389.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/8] partitions/efi: detect hybrid mbrs
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>,
        Jim Hull <jim.hull@hp.com>, Karel Zak <kzak@redhat.com>,
        Peter Jones <pjones@redhat.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Date: Thu, 15 Aug 2013 18:37:19 -0700
In-Reply-To: <20130815122949.aff0bc4821e4adaec8eb359b@linux-foundation.org>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
	 <20130806141603.948961cecfc9426aeee7c083@linux-foundation.org>
	 <1376585982.2152.2.camel@buesod1.americas.hpqcorp.net>
	 <20130815122949.aff0bc4821e4adaec8eb359b@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-15 at 12:29 -0700, Andrew Morton wrote:
> On Thu, 15 Aug 2013 09:59:42 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > On Tue, 2013-08-06 at 14:16 -0700, Andrew Morton wrote:
> > > On Mon,  5 Aug 2013 22:21:08 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > 
> > > > This patchset teaches the kernel about hybrid master boot records (MBRs), one of
> > > > the most common issues with GUID partition tables, as a workaround to layout
> > > > disk partitions to be compatible with both EFI and legacy MBR based systems.
> > > > Except for adding more pmbr checks, to better comply with the UEFI/GPT specs, the
> > > > functionality is left unchanged - we only inform (through debug) the user about
> > > > the used MBR scheme. While it is true that these restrictions can be bypassed when
> > > > forcing gpt, this is not the correct or default way of doing things, complicating
> > > > users furthermore. More details are in the individual patches.
> > > 
> > > Patches look nice, although I'll cheerily admit to not having a clue
> > > what they do.  What is a "hybrid MBR" anyway?
> > > 
> > > Someone's editor seems to replace tabs with spaces so the patches
> > > generate quite a checkpatch storm.  Please use checkpatch.
> > > 
> > 
> > Andrew, any chance of getting this in for 3.12?
> 
> gee, I didn't review the patches because I simply have no useful
> knowledge in the area.  I can check the whitespace and code comments,
> but that has the downside of creating the false impression that someone
> actually reviewed the code :(
> 
> I'm struggling to think who might be better situated.  Matt Fleming or
> Matt Domsch, maybe?
> 

Cc'ing Matt Fleming.

Karel, I believe you took a look at these, any thoughts?

Thanks,
Davidlohr

