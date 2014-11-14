Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbaKNA3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:29:21 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:56635 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933993AbaKNA3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:29:20 -0500
From: Joe Stringer <joestringer@nicira.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCHv2 net 2/2] fm10k: Implement ndo_gso_check()
Date: Thu, 13 Nov 2014 16:29:16 -0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shannon Nelson <shannon.nelson@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>, netdev@vger.kernel.org,
        matthew.vick@intel.com, linux.nics@intel.com, therbert@google.com,
        gerlitz.or@gmail.com, alexander.duyck@gmail.com,
        linux-kernel@vger.kernel.org, jesse@nicira.com
References: <1415921801-10452-1-git-send-email-joestringer@nicira.com> <20141113235219.GA35957@gmail.com> <1415923959.2454.44.camel@jtkirshe-mobl>
In-Reply-To: <1415923959.2454.44.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411131629.16621.joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 13, 2014 16:12:39 Jeff Kirsher wrote:
> On Thu, 2014-11-13 at 15:52 -0800, Joe Stringer wrote:
> > On Thu, Nov 13, 2014 at 03:41:56PM -0800, Jeff Kirsher wrote:
> > > On Thu, 2014-11-13 at 15:36 -0800, Joe Stringer wrote:
> > > > ndo_gso_check() was recently introduced to allow NICs to report
> > 
> > the
> > 
> > > > offloading support that they have on a per-skb basis. Add an
> > > > implementation for this driver which checks for something that
> > 
> > looks
> > 
> > > > like VXLAN.
> > > > 
> > > > Signed-off-by: Joe Stringer <joestringer@nicira.com>
> > > > ---
> > > > v2: Reuse fm10k_tx_encap_offload().
> > > > ---
> > > > 
> > > >  drivers/net/ethernet/intel/fm10k/fm10k.h        |    1 +
> > > >  drivers/net/ethernet/intel/fm10k/fm10k_main.c   |    2 +-
> > > >  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c |    8 ++++++++
> > > >  3 files changed, 10 insertions(+), 1 deletion(-)
> > > 
> > > Same with this one as well, thanks Joe.
> > 
> > Thanks Jeff.
> > 
> > Could you remind me, is the equivalent i40e patch on your queue or
> > were
> > we still waiting on further feedback from Shannon/Jesse?
> 
> Actually, looks like I dropped the patch due to community feedback and
> was expecting a v2.  Was I incorrect in doing so?

That's fine. There were some unresolved questions for what that version should 
look like, but I can repost to start the discussion again.

Cheers,
Joe
