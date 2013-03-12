Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3CLG3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:29:35 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43848 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3CLG3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:29:33 -0400
Date: Tue, 12 Mar 2013 14:44:49 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: torrent hash failures since 3.9.0-rc1
Message-ID: <20130312064449.GA8806@gmail.com>
Mail-Followup-To: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
References: <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
 <20130312030057.GA6142@gmail.com>
 <20130312033054.GB18595@thunk.org>
 <20130312061624.GA436@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312061624.GA436@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 07:16:24AM +0100, Markus Trippelsdorf wrote:
> On 2013.03.11 at 23:30 -0400, Theodore Ts'o wrote:
> > On Tue, Mar 12, 2013 at 11:00:58AM +0800, Zheng Liu wrote:
> > > 
> > > Thanks for reporting this problem.  My deepest apologies.
> > > 
> > > As Ted suggested, could you please try to use ext4 git tree?  I want to
> > > make sure whether this bug has been fixed by my lastest patch series or
> > > not.
> > 
> > It's definitely worth a try to compile the master branch of the ext4
> > tree and see if it reproduces or not.
> 
> I cannot reproduce the issue on top of "ext4.git dev", so fortunately
> the problem seems to be already fixed there.
> Thanks.

Great!  Thanks for the confirmation.

> 
> Do you guys have a hunch which commit is the actual fix? 
> (Maybe I will "bisect" it later today.)

I think maybe this two commits can fix it, but I am not sure which one
is the actual fix (I guess it is the former one, ;-) ).  Please try it
if you could bisect it.  Thanks in advance.

 * 079d7667af20876a59a1d9b0d4d1e15dcf17fa34
   ext4: fix wrong the number of the allocated blocks in
ext4_split_extent()

 * cdee78433c138c2f2018a6884673739af2634787
   ext4: fix wrong m_len value after unwritten extent conversion

Regards,
                                                - Zheng
