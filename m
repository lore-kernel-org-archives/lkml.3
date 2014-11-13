Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845AbaKMXwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:52:30 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51148 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934400AbaKMXw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:52:29 -0500
Date: Thu, 13 Nov 2014 15:52:19 -0800
From: Joe Stringer <joestringer@nicira.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Shannon Nelson <shannon.nelson@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: netdev@vger.kernel.org, matthew.vick@intel.com, linux.nics@intel.com,
        therbert@google.com, gerlitz.or@gmail.com, alexander.duyck@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net 2/2] fm10k: Implement ndo_gso_check()
Message-ID: <20141113235219.GA35957@gmail.com>
Mail-Followup-To: Joe Stringer <joestringer@nicira.com>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	Shannon Nelson <shannon.nelson@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	netdev@vger.kernel.org, matthew.vick@intel.com,
	linux.nics@intel.com, therbert@google.com, gerlitz.or@gmail.com,
	alexander.duyck@gmail.com, linux-kernel@vger.kernel.org
References: <1415921801-10452-1-git-send-email-joestringer@nicira.com>
 <1415921801-10452-2-git-send-email-joestringer@nicira.com>
 <1415922116.2454.34.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415922116.2454.34.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 03:41:56PM -0800, Jeff Kirsher wrote:
> On Thu, 2014-11-13 at 15:36 -0800, Joe Stringer wrote:
> > ndo_gso_check() was recently introduced to allow NICs to report the
> > offloading support that they have on a per-skb basis. Add an
> > implementation for this driver which checks for something that looks
> > like VXLAN.
> > 
> > Signed-off-by: Joe Stringer <joestringer@nicira.com>
> > ---
> > v2: Reuse fm10k_tx_encap_offload().
> > ---
> >  drivers/net/ethernet/intel/fm10k/fm10k.h        |    1 +
> >  drivers/net/ethernet/intel/fm10k/fm10k_main.c   |    2 +-
> >  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c |    8 ++++++++
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> Same with this one as well, thanks Joe.

Thanks Jeff.

Could you remind me, is the equivalent i40e patch on your queue or were
we still waiting on further feedback from Shannon/Jesse?
