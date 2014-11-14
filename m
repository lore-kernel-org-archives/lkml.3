Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712AbaKNAyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:54:25 -0500
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:44487 "HELO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934546AbaKNAyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:54:23 -0500
From: Joe Stringer <joestringer@nicira.com>
To: "Vick, Matthew" <matthew.vick@intel.com>
Subject: Re: [PATCHv2 net 1/2] fm10k: Check tunnel header length in encap offload
Date: Thu, 13 Nov 2014 16:54:19 -0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "therbert@google.com" <therbert@google.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1415921801-10452-1-git-send-email-joestringer@nicira.com> <D08A8E37.5FC83%matthew.vick@intel.com>
In-Reply-To: <D08A8E37.5FC83%matthew.vick@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201411131654.19998.joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 13, 2014 16:41:03 Vick, Matthew wrote:
> On 11/13/14, 3:36 PM, "Joe Stringer" <joestringer@nicira.com> wrote:
> >fm10k supports up to 184 bytes of inner+outer headers. Add an initial
> >check to fail encap offload if these are too large.
> >
> >Signed-off-by: Joe Stringer <joestringer@nicira.com>
> >---
> >Matthew, I didn't see the equivalent patch on netdev so I went ahead and
> >created it. If I've missed this somewhere, then please disregard.
> >
> >v2: First post.
> 
> You didn't miss it Joe--it just hasn't made it up yet. :) It's currently
> in Jeff's tree for testing. You're on the CC for the patch, so you'll get
> a notification once it goes up. It's basically the same as what you have,
> except the #define I use is 184 and I use inner_tcp_hdrlen() to account
> for the inner TCP header length.
> 
> Since your second patch should apply cleanly on top of mine, what do you
> think about dropping the first patch in this series and Jeff can send our
> two patches up together once they've passed testing?

Ah, that sounds great.

Cheers,
Joe
