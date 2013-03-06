Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3CFENw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:13:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13146 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3CFENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:13:48 -0500
X-AuditID: cbfee68d-b7f636d0000009be-48-5136c27bb08c
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
Date: Wed, 06 Mar 2013 13:13:46 +0900
Message-id: <022601ce1a20$ff6b2290$fe4167b0$%an@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q/zAZ6zgR9pxOQICfDbt0F93/+wJEA5Ow
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zfd3qQ2aBBss/sVu8PKRpMed8C4vF
	ic33GS16F1xls7i8aw6bxbEFYhb/X29ldGD32LLyJpPH4j0vmTz6tqxi9Hj6Yy+zx+dNcgGs
	UVw2Kak5mWWpRfp2CVwZj093sRU8dqh48DSsgXGpbhcjJ4eEgInE1j0bWCBsMYkL99azdTFy
	cQgJLGOU+LFkMxtM0f7pHYwQiemMEmv/bWOFcH4xSrT9mcgKUsUmoCbRPPMyWIeIgKHEn5WN
	zCA2s8BURokl72VBbCGB54wSj68AxTk4OAVUJPb84QAJCwvESWy59pgRxGYRUJW48n8N2Ehe
	ARuJTc/aoWxBiR+T77FAjNSSWL/zOBOELS+xec1bsJESAuoSj/7qQlxgJDF7z3FWiBIRiX0v
	3oHdLyHwiF2i48kOJohdAhLfJh9igeiVldh0gBniX0mJgytusExglJiFZPMsJJtnIdk8C8mK
	BYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFC4rZ3B+PtA9aHGJOB1k9klhJNzgfGfV5J
	vKGxsYmZiamJuaWpuSlpwkrivHKXZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MG5cFvjf
	jOWB3t9iE6YtS1aE7144LUqy6/fWZ9fMZu5jCVQ/IDd1u0q6zEE/UZZ14V2yqU+dPn9/8UOQ
	v2obe3bPy8v9n9fYyJmmLkmYWnllC4PNlyjGO9EWceav+8tOZEdOSlXYZ8OhvX352XkV7HMd
	+K/6cUQt2L7ioC8zd472KQVV94dt4kosxRmJhlrMRcWJAHxsX/nxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQd3qQ2aBBjN/Mlq8PKRpMed8C4vF
	ic33GS16F1xls7i8aw6bxbEFYhb/X29ldGD32LLyJpPH4j0vmTz6tqxi9Hj6Yy+zx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMx6f7mIreOxQ8eBpWAPjUt0u
	Rk4OCQETif3TOxghbDGJC/fWs3UxcnEICUxnlFj7bxsrhPOLUaLtz0RWkCo2ATWJ5pmX2UBs
	EQFDiT8rG5lBbGaBqYwSS97LgthCAs8ZJR5fAYpzcHAKqEjs+cMBEhYWiJPYcu0x2DIWAVWJ
	K//XgI3kFbCR2PSsHcoWlPgx+R4LxEgtifU7jzNB2PISm9e8BRspIaAu8eivLsQFRhKz9xxn
	hSgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJ
	EZwUnkntYFzZYHGIUYCDUYmH10LJLFCINbGsuDL3EKMEB7OSCO+7ZUAh3pTEyqrUovz4otKc
	1OJDjMlAj05klhJNzgcmrLySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnNTk0tSC2C
	2cLEwSnVwGgZLcXEdHlH1DqzCFtODfbwz96svey5webqMw+wS6bLOUk33Pn5xehI4cxuhYUl
	RY3hT/e0+xw5tuE/Y+ayt248a8sbXF/dvMW8zrh3ZdmWzbcPHjwcJG59dNvNQwztXee5Fx73
	lJytsr35msvt7rYvmTFdD17bChmX2K1m9d91iVvD5U3eNyWW4oxEQy3mouJEAF7GZl5OAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peppe,
> Hello Byungho
> 
> sorry for my late reply. I'm attaching two patches built for net-next
> as we had clarified. I had written the first patch long time ago
> and on top of it I have added some part of your code below with some
> fixes (see also the comments inline below).
> 
> This work is not yet completed but I do hope these two patches will
> help you to complete all. Unfortunately, I cannot do any tests
> because I have no HW that supports PCS. :-(
> 
> In the second patch, take a look at the comment that reports
> the missing parts. For example, ethtool, SGMII etc.
> 
> I wonder if you could review/test the two patches on your side.

Looks good to me and it works fine on my hardware platform. Just note, I
tested them with some additional stuff which is in stmmac_init_phy() and
stmmac_mdio_register() for SGMII.

> Also I hope you can improve all adding the missing features (that is
> what you were already doing).
> 
> If you agree, you could also re-send *all* to the mailing list to
> be finally reviewed.
> 

Anyway, in my opinion, you can take them in your tree for now with my
tested-by if you want. Of course, I'll implement additional patches as you
requested on top of them for remained stuff such as SGMII, TBI, ethtool and
so on.
I think those should be separated for each purpose and we can add and modify
after those two patches.

On 2/22/2013 10:418 PM, Giuseppe CAVALLARO wrote:
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

this part is already in the second patch. I think restart flag should be 0
because auto-negotiation does not restarted in the stmmac_open function.

> 
> > And ctrl_ane funciont is like that
> >
> > @@ -311,6 +317,18 @@ static void dwmac1000_set_autoneg(void __iomem
> *ioaddr)
> >          writel(value, ioaddr + GMAC_AN_CTRL);
> >   }
> >
> > +static void dwmac1000_ctrl_ane(void __iomem *ioaddr, bool restart)
> > +{
> > +       u32 value;
> > +
> > +       value = readl(ioaddr + GMAC_AN_CTRL);
> > +     /* auto negotiation enable and External Loopback enable */
> > +       value = GMAC_AN_CTRL__ANE | GMAC_AN_CTRL__ELE;
> > +
> > +       if (restart)
> > +               value |= GMAC_AN_CTRL_RAN;
> > +
> > +       writel(value, ioaddr + GMAC_AN_CTRL);
> > +}
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
> > +stmmac_nway_reset(struct net_device *netdev)
> > +{
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
> pay attention that also some other ethtool functions have to be fixed
> for this support.
> 

I agree with you, I need more time to test ethtool support including
advertisement support.

> [snip]
> 
> > I think whenever link is changed, phy->state is changed and call
> > stmmac_adjust_link. It would update gmac's link.
> > I can get autonegotiation complete and link change irqs if we need
> something
> > we can add code in the handler but I'm not sure which one is need yet.
> > As of now I just added phy_state = PHY_CHANGELINK as a test code in the
> link
> > change irq handler.
> >
> > @@ -1624,8 +1629,43 @@ static irqreturn_t stmmac_interrupt(int irq, void
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
> > +                                       if ((priv->speed != phy->speed)
||
> > (priv->oldduplex != phy->duplex))
> > +                                       phy->state = PHY_CHANGELINK;  /*
for
> > test */
> > +                       }
> >
> >                          /* For LPI we need to save the tx status */
> >                          if (status & core_irq_tx_path_in_lpi_mode) {
> >
> > I have a question, how to hand over phy's irq number, as I analyzed
> > phydev->irq is irqlist and irqlist is like below but I can not find a
> way to
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
> > I added some defines for AN like below
> > @@ -97,6 +97,20 @@ enum power_event {
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

