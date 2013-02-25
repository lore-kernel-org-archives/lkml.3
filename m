Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3BYK2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:28:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29952 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426Ab3BYK2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:28:12 -0500
X-AuditID: cbfee690-b7f6b6d000004563-a0-512b3cbaea08
From: Byungho An <bh74.an@samsung.com>
To: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com, cpgs@samsung.com
References: <00c001cdf369$9b25bdf0$d17139d0$@samsung.com>
 <50F6568D.3060703@st.com> <01e201cdf5a3$1f3e1890$5dba49b0$@samsung.com>
 <50FFB094.5000100@st.com> <013e01cdfb47$8f5d2b30$ae178190$@samsung.com>
 <51277004.20702@st.com>
In-reply-to: <51277004.20702@st.com>
Subject: RE: [PATCH net-next 1/3] net: stmmac: add gmac autoneg set for SGMII,
 TBI, and RTBI
Date: Mon, 25 Feb 2013 19:28:09 +0900
Message-id: <002701ce1342$ced296c0$6c77c440$%an@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q/zAZ6zgR9pxOQICfDbt0F93/+wCQ1ajQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA91dNtqBBj1T5S0u75rDZnFsgZgD
	k8fnTXIBjFFcNimpOZllqUX6dglcGTfnpBc0Wle8WH6crYHxqkYXIyeHhICJxO1rp5khbDGJ
	C/fWs3UxcnEICSxjlFjSsoQFpmjK/c+MEIlFjBLT3i+Ecn4xSvTsfs4KUsUmoCbRPPMyG4gt
	ImAo8WdlI9hYZoGpQKPey4LYQgLPGSUeXwGKc3BwCqhI7PnDARIWFoiT2HLtMSOIzSKgKvHg
	xX1WkBJeARuJzR3OIGFeAUGJH5PvsUBM1JJYv/M4E4QtL7F5zVuwiRIC6hKP/uqCmCICRhJP
	/1lDVIhI7HvxDuxgCYFV7BJzN7xkhtgkIPFt8iEWiFZZiU0HoMEgKXFwxQ2WCYwSs5AsnoVk
	8Swki2chWbGAkWUVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRkhsTdjBeO+A9SHGZKD1E5ml
	RJPzgbGZVxJvaGxsYmZiamJuaWpuSpqwkjiv/CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2MAg0XnLLchH+GZCj9N7rweUH7AxWW0g2TmQ8uufiOuSuz59tii7PyJusfythLzk3KP670
	+RpPK0Mzz4yFL74zMhzpeNQfHBS9QNPylhHXzeWbp39pbTjbuMo35tdhl02X/1yzl1c2WuG3
	xkXk4PUnCUcffjKfkj3TJWjpyT//Izsrru7aJzJNT4mlOCPRUIu5qDgRANgEtDfDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO4uG+1Ag/vnJCwu75rDZnFsgZgD
	k8fnTXIBjFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6
	bpk5QJOVFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBk356QXNFpXvFh+
	nK2B8apGFyMnh4SAicSU+58ZIWwxiQv31rN1MXJxCAksYpSY9n4hI4Tzi1GiZ/dzVpAqNgE1
	ieaZl9lAbBEBQ4k/KxuZQWxmgamMEkvey4LYQgLPGSUeXwGKc3BwCqhI7PnDARIWFoiT2HLt
	MdgyFgFViQcv7rOClPAK2Ehs7nAGCfMKCEr8mHyPBWKilsT6nceZIGx5ic1r3oJNlBBQl3j0
	VxfEFBEwknj6zxqiQkRi34t3jBMYhWYhGTQLyaBZSAbNQtKygJFlFaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZw5D6T3sG4qsHiEKMAB6MSD2/DSq1AIdbEsuLK3EOMEhzMSiK8SSbagUK8
	KYmVValF+fFFpTmpxYcYk4HenMgsJZqcD0wqeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAk
	kJ5YkpqdmlqQWgSzhYmDU6qBsfCP/je2eSufirDed9DI31Px1GMll2kRZ4qnTG32prmhc61z
	i2L7pCZ/Sb1t/qLrpnZg9Kk+ywYPe+9TJRuP6OyMWN1qffLFjU1iQlxuJoFcDg9v6sY8vvaA
	5f+aiuTAAraz2n/vHdv7UCG8LmDVn9tTVpnPruA8UWv76ULRY6urZ3n7Uv45KbEUZyQaajEX
	FScCAHwgnY0gAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peppe,

I'll check patches and test on my side soon.
After that share with you.

Thank you.
> Hello Byungho
> 
> sorry for my late reply. I'm attaching two patches built for net-next as
> we had clarified. I had written the first patch long time ago and on top
> of it I have added some part of your code below with some fixes (see also
> the comments inline below).
> 
> This work is not yet completed but I do hope these two patches will help
> you to complete all. Unfortunately, I cannot do any tests because I have
> no HW that supports PCS. :-(
> 
> In the second patch, take a look at the comment that reports the missing
> parts. For example, ethtool, SGMII etc.
> 
> I wonder if you could review/test the two patches on your side.
> Also I hope you can improve all adding the missing features (that is what
> you were already doing).
> 
> If you agree, you could also re-send *all* to the mailing list to be
> finally reviewed.
> 
> On 1/25/2013 11:01 PM, Byungho An wrote:
> >
> > On 1/23/2013 1:43 PM, Giuseppe CAVALLARO write:
> 
> [snip]
> 
> >>
> > I modified this part like below
> >
> > @@ -1044,12 +1046,8 @@ static int stmmac_open(struct net_device *dev)
> >          priv->hw->mac->core_init(priv->ioaddr);
> >
> >          /* Enable auto-negotiation for SGMII, TBI or RTBI */
> > -       if (interface == PHY_INTERFACE_MODE_SGMII ||
> > -           interface == PHY_INTERFACE_MODE_TBI ||
> > -           interface == PHY_INTERFACE_MODE_RTBI) {
> > -               if (priv->phydev->autoneg)
> > -                       priv->hw->mac->set_autoneg(priv->ioaddr);
> > -       }
> > +       if (priv->dma_cap.pcs)
> > +               priv->hw->mac->ctrl_ane(priv->ioaddr, 0);
> >
> >          /* Request the IRQ lines */
> >          ret = request_irq(dev->irq, stmmac_interrupt,
> >
> > As you may know, auto-negotiation is essential for SGMII, TBI, or RTBI
> > interface.
> >
> 
> good, add it on top of the second patch.
> 
> > And ctrl_ane funciont is like that
> >
> > @@ -311,6 +317,18 @@ static void dwmac1000_set_autoneg(void __iomem
> *ioaddr)
> >          writel(value, ioaddr + GMAC_AN_CTRL);
> >   }
> >
> > +static void dwmac1000_ctrl_ane(void __iomem *ioaddr, bool restart) {
> > +       u32 value;
> > +
> > +       value = readl(ioaddr + GMAC_AN_CTRL);
> > +     /* auto negotiation enable and External Loopback enable */
> > +       value = GMAC_AN_CTRL__ANE | GMAC_AN_CTRL__ELE;
> > +
> > +       if (restart)
> > +               value |= GMAC_AN_CTRL_RAN;
> > +
> > +       writel(value, ioaddr + GMAC_AN_CTRL); }
> >
> >   static const struct stmmac_ops dwmac1000_ops = {
> >          .core_init = dwmac1000_core_init,
> 
> well done and added in the second patch.
> 
> [snip]
> > I've  changed restart AN like below.
> >
> > @@ -610,6 +607,27 @@ static int stmmac_set_coalesce(struct net_device
> *dev,
> >          return 0;
> >   }
> >
> > +static int
> > +stmmac_nway_reset(struct net_device *netdev) {
> > +       struct stmmac_priv *priv = netdev_priv(netdev);
> > +       struct phy_device *phy = priv->phydev;
> > +       int ret = 0;
> > +
> > +       spin_lock(&priv->lock);
> > +
> > +       if (netif_running(netdev)) {
> > +               phy_stop(phy);
> > +               phy_start(phy);
> > +               ret = phy_start_aneg(phy);
> > +               if (priv->dma_cap.pcs)
> > +                       priv->hw->mac->ctrl_ane(priv->ioaddr, true);
> > +       }
> > +
> > +       spin_unlock(&priv->lock);
> > +       return ret;
> > +}
> > +
> >   static const struct ethtool_ops stmmac_ethtool_ops = {
> >          .begin = stmmac_check_if_running,
> >          .get_drvinfo = stmmac_ethtool_getdrvinfo,
> >
> >
> 
> we have to review this. I expect to have a new patch that includes the
> ethtool support but, at first glance, the stmmac_nway_reset should only
> call the ctrl_ane.
> 
> pay attention that also some other ethtool functions have to be fixed for
> this support.
> 
> [snip]
> 
> > I think whenever link is changed, phy->state is changed and call
> > stmmac_adjust_link. It would update gmac's link.
> > I can get autonegotiation complete and link change irqs if we need
> > something we can add code in the handler but I'm not sure which one is
> need yet.
> > As of now I just added phy_state = PHY_CHANGELINK as a test code in
> > the link change irq handler.
> >
> > @@ -1624,8 +1629,43 @@ static irqreturn_t stmmac_interrupt(int irq,
> > void
> > *dev_id)
> >
priv->xstats.mmc_rx_csum_offload_irq_n++;
> >                          if (status & core_irq_receive_pmt_irq)
> >                                  priv->xstats.irq_receive_pmt_irq_n++;
> > +                       if (status & core_irq_pcs_autoneg_complete)
> > +                                priv->core_pcs_an = true;
> > +                       if (status & core_irq_pcs_link_status_change) {
> > +                               priv->core_pcs_link_change = true;
> > +                               status = readl(priv->ioaddr +
> > GMAC_AN_STATUS);
> > +                               if (status & GMAC_AN_STATUS_LS)
> > +                                       if ((priv->speed !=
> > + phy->speed) ||
> > (priv->oldduplex != phy->duplex))
> > +                                       phy->state = PHY_CHANGELINK;
> > + /* for
> > test */
> > +                       }
> >
> >                          /* For LPI we need to save the tx status */
> >                          if (status & core_irq_tx_path_in_lpi_mode) {
> >
> > I have a question, how to hand over phy's irq number, as I analyzed
> > phydev->irq is irqlist and irqlist is like below but I can not find a
> > phydev->way to
> > set phy's irq number.
> > How to register or set priv->mii_irq or mdio_bus_data->irqs.
> >
> >          if (mdio_bus_data->irqs)
> >                  irqlist = mdio_bus_data->irqs;
> >          else
> >                  irqlist = priv->mii_irq;
> 
> I had added something in my first patch that should be ok.
> 
> > I added some defines for AN like below @@ -97,6 +97,20 @@ enum
> > power_event {
> >   #define GMAC_TBI       0x000000d4      /* TBI extend status */
> >   #define GMAC_GMII_STATUS 0x000000d8    /* S/R-GMII status */
> >
> > +/* AN Configuration defines */
> > +#define GMAC_AN_CTRL_RAN       0x00000200      /* Restart
Auto-Negotiation
> > */
> > +#define GMAC_AN_CTRL_ANE       0x00001000      /* Auto-Negotiation
Enable
> > */
> > +#define GMAC_AN_CTRL_ELE       0x00004000      /* External Loopback
Enable
> > */
> > +#define GMAC_AN_CTRL_ECD       0x00010000      /* Enable Comma Detect
*/
> > +#define GMAC_AN_CTRL_LR        0x00020000      /* Lock to Reference */
> > +#define GMAC_AN_CTRL_SGMRAL    0x00040000      /* SGMII RAL Control */
> > +
> > +/* AN Status defines */
> > +#define GMAC_AN_STATUS_LS      0x00000004      /* Link Status 0:down
1:up
> > */
> > +#define GMAC_AN_STATUS_ANA     0x00000008      /* Auto-Negotiation
> Ability
> > */
> > +#define GMAC_AN_STATUS_ANC     0x00000020      /* Auto-Negotiation
> Complete
> > */
> > +#define GMAC_AN_STATUS_ES      0x00000100      /* Extended Status */
> > +
> >   /* GMAC Configuration defines */
> >   #define GMAC_CONTROL_TC        0x01000000      /* Transmit Conf. in
> > RGMII/SGMII */
> >   #define GMAC_CONTROL_WD        0x00800000      /* Disable Watchdog on
> > receive */
> 
> ok, these are in the second patch

