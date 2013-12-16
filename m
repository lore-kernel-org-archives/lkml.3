Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3LPSWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:22:23 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42575 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3LPSWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:22:21 -0500
X-Originating-IP: 173.246.103.110
Date: Mon, 16 Dec 2013 10:22:09 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Abodunrin, Akeem G" <akeem.g.abodunrin@intel.com>,
        "Vick, Matthew" <matthew.vick@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/9] drivers: net: Remove unused function
 igb_get_eee_status_i354() in e1000_82575.c
Message-ID: <20131216182209.GB7464@jtriplet-mobl1>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
 <9BBC4E0CF881AA4299206E2E1412B6264FA1408B@ORSMSX102.amr.corp.intel.com>
 <20131216174312.GA26982@jtriplet-mobl1>
 <9BBC4E0CF881AA4299206E2E1412B6264FA142AA@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9BBC4E0CF881AA4299206E2E1412B6264FA142AA@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 06:17:40PM +0000, Wyborny, Carolyn wrote:
> 
> 
> > -----Original Message-----
> > From: Josh Triplett [mailto:josh@joshtriplett.org]
> > Sent: Monday, December 16, 2013 9:43 AM
> > To: Wyborny, Carolyn
> > Cc: Rashika Kheria; linux-kernel@vger.kernel.org; Kirsher, Jeffrey T; Brandeburg,
> > Jesse; Allan, Bruce W; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr,
> > Peter P; Duyck, Alexander H; Ronciak, John; Dave, Tushar N; Abodunrin, Akeem
> > G; Vick, Matthew; e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org
> > Subject: Re: [PATCH v2 1/9] drivers: net: Remove unused function
> > igb_get_eee_status_i354() in e1000_82575.c
> > 
> > On Mon, Dec 16, 2013 at 05:11:25PM +0000, Wyborny, Carolyn wrote:
> > > > -----Original Message-----
> > > > From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
> > > > Sent: Saturday, December 14, 2013 4:15 AM
> > > > To: linux-kernel@vger.kernel.org
> > > > Cc: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
> > > > Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr, Peter
> > > > P; Duyck, Alexander H; Ronciak, John; Dave, Tushar N; Abodunrin,
> > > > Akeem G; Vick, Matthew; e1000- devel@lists.sourceforge.net;
> > > > netdev@vger.kernel.org; josh@joshtriplett.org
> > > > Subject: [PATCH v2 1/9] drivers: net: Remove unused function
> > > > igb_get_eee_status_i354() in e1000_82575.c
> > > >
> > > > This patch removes the function igb_get_eee_status_i354() in
> > > > e1000_82575.c because it is unused.
> > > >
> > > > It thus eliminates the following warning in
> > > > ethernet/intel/igb/e1000_82575.c:
> > > > drivers/net/ethernet/intel/igb/e1000_82575.c:2591:5: warning: no
> > > > previous prototype for ‘igb_get_eee_status_i354’
> > > > [-Wmissing-prototypes]
> > > >
> > > > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > > ---
> > > >  drivers/net/ethernet/intel/igb/e1000_82575.c |   32 --------------------------
> > > >  1 file changed, 32 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c
> > > > b/drivers/net/ethernet/intel/igb/e1000_82575.c
> > > > index 47c2d10..18e5200 100644
> > > > --- a/drivers/net/ethernet/intel/igb/e1000_82575.c
> > > > +++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
> > > > @@ -2580,38 +2580,6 @@ out:
> > > >  	return ret_val;
> > > >  }
> > > >
> > > > -/**
> > > > - *  igb_get_eee_status_i354 - Get EEE status
> > > > - *  @hw: pointer to the HW structure
> > > > - *  @status: EEE status
> > > > - *
> > > > - *  Get EEE status by guessing based on whether Tx or Rx LPI
> > > > indications have
> > > > - *  been received.
> > > > - **/
> > > > -s32 igb_get_eee_status_i354(struct e1000_hw *hw, bool *status) -{
> > > > -	struct e1000_phy_info *phy = &hw->phy;
> > > > -	s32 ret_val = 0;
> > > > -	u16 phy_data;
> > > > -
> > > > -	/* Check if EEE is supported on this device. */
> > > > -	if ((hw->phy.media_type != e1000_media_type_copper) ||
> > > > -	    (phy->id != M88E1543_E_PHY_ID))
> > > > -		goto out;
> > > > -
> > > > -	ret_val = igb_read_xmdio_reg(hw, E1000_PCS_STATUS_ADDR_I354,
> > > > -				     E1000_PCS_STATUS_DEV_I354,
> > > > -				     &phy_data);
> > > > -	if (ret_val)
> > > > -		goto out;
> > > > -
> > > > -	*status = phy_data & (E1000_PCS_STATUS_TX_LPI_RCVD |
> > > > -			      E1000_PCS_STATUS_RX_LPI_RCVD) ? true : false;
> > > > -
> > > > -out:
> > > > -	return ret_val;
> > > > -}
> > > > -
> > > >  static const u8 e1000_emc_temp_data[4] = {
> > > >  	E1000_EMC_INTERNAL_DATA,
> > > >  	E1000_EMC_DIODE1_DATA,
> > > > --
> > > > 1.7.9.5
> > >
> > > NACK.
> > >
> > > Thanks for the patch Rashika, but this is the incorrect fix for this
> > > warning  The function is called in the igb_probe function, so you
> > > cannot remove it and I see the prototype in the e1000_82575.h file.
> > > Can you double check your source pull?
> > 
> > From top-of-tree linux.git:
> > 
> > ~/src/linux$ git grep igb_get_eee_status_i354
> > drivers/net/ethernet/intel/igb/e1000_82575.c: *  igb_get_eee_status_i354 - Get
> > EEE status
> > drivers/net/ethernet/intel/igb/e1000_82575.c:s32jjj
> > igb_get_eee_status_i354(struct e1000_hw *hw, bool *status)
> > 
> > A comment and the function itself; no other references.  In what tree are you
> > seeing a reference to igb_get_eee_status_i354?
> > 
> > - Josh Triplett
> 
> Thanks Josh,
> 
> My mistake.  I was looking at the "get" not "set" function.  However, this is still not the right fix for the driver as the actual problem is the missing code that is supposed to be calling that function in igb_get_eee in igb_ethtool.c.  The function needs to stay.  I will submit the correct fix ASAP.

Ah, that makes sense.  Can you please Cc Rashika and myself on that
patch, with a Reported-by for Rashika?

- Josh Triplett
