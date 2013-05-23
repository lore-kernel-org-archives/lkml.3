Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3EWBFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:05:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab3EWBFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:05:09 -0400
Date: Wed, 22 May 2013 20:19:58 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com
Subject: Re: microcode loading got really slow.
Message-ID: <20130523001957.GA32651@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	fenghua.yu@intel.com
References: <20130521230332.GC12713@redhat.com>
 <519D1668.6000601@zytor.com>
 <20130522200012.GA15456@redhat.com>
 <ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:09:52PM -0700, H. Peter Anvin wrote:

 > Dave Jones <davej@redhat.com> wrote:
 > 
 > >On Wed, May 22, 2013 at 12:03:04PM -0700, H. Peter Anvin wrote:
 > > > On 05/21/2013 04:03 PM, Dave Jones wrote:
 > > > > In 3.10-rc2 I see this happening..
 > > > > 
 > > > > [   72.318133] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x6
 > > > > [  132.446449] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x6
 > > > > [  192.573101] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x6
 > >> > [  252.702055] microcode: Microcode Update Driver: v2.00
 > ><tigran@aivazian.fsnet.co.uk>, Peter Oruba
 > > > > 
 > >> > For some reason the events for udev seem to be getting delayed 60s
 > >for each core.
 > > > > 
 > > > > 	Dave
 > > > > 
 > > > 
 > > > Is this a regression from -rc1?
 > >
 > >No. Looks like it was introduced between 3.9 and 3.10-rc1
 > >
 > >I see bisecting in my future.
 > >
 > A bisect would be appreciated.  Cc Fenghua.

Turns out that I can reproduce this on 3.9 too (and likely earlier) with the right
config file.  I'm not sure what option causes the delay yet. Isolating differences
between configs now.

	Dave

