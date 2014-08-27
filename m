Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaH0B62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:58:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20037 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaH0B6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:58:25 -0400
X-AuditID: cbfee691-f79546d0000011a1-b1-53fd3b3ebe30
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, kgene.kim@samsung.com,
        mathias.nyman@intel.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, heikki.krogerus@linux.intel.com,
        balbi@ti.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1408632923-19591-1-git-send-email-gautam.vivek@samsung.com>
 <1408632923-19591-5-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1408632923-19591-5-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH v5 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for
 exynos5420/5800
Date: Wed, 27 Aug 2014 10:58:21 +0900
Message-id: <000001cfc19a$6190fd10$24b2f730$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+9UA4uFMs3GL8LTui+WSGurzKqHQESUWqA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zQ10767/BBqs+qVscvF9v0XblILtF
	8+L1bBZdq3eyWFxeeInVonfBVTaLC0972Cwu75rDZjHj/D4mi0XLWpktmjdNYbU4s+oWu8WE
	3xfYHHg9Hkz9z+SxeM9LJo95JwM99s9dw+4x++4PRo++LasYPY7f2M7k8XmTXABHFJdNSmpO
	Zllqkb5dAlfG4kXfGAs2e1dMOF7SwDjftouRk0NCwETi6fQuVghbTOLCvfVsXYxcHEICyxgl
	Vk55zA5TdHr5bmaIxHRGiabnn1ggnN+MEkduv2cEqWITUJP48uUwWIeIgIfE3WPLwWxmgR1M
	EntnZUE0tDNKbFp+mA0kwSngKXFn/TewImGBaImFN5eD3cEioCrxfuMBZhCbV8BW4v3EvywQ
	tqDEj8n3WCCGakms33mcCcKWl9i85i1QPQfQqeoSj/7qgpgiAkYSO9Z4Q1SISOx78Y4R5AQJ
	gZUcEm9WLmGEWCUg8W3yIRaIVlmJTRBbJQQkJQ6uuMEygVFiFpLFs5AsnoVk8SwkKxYwsqxi
	FE0tSC4oTkovMtUrTswtLs1L10vOz93ECEkJE3cw3j9gfYhRgINRiYf3w4I/wUKsiWXFlbmH
	GE2BLprILCWanA9MPHkl8YbGZkYWpiamxkbmlmZK4rw60j+DhQTSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTDKLfP7x6D8gmWDhPX0xoh13m1fHu7UP+xQ+2H/4cOs9Vf0VdZ+kHlx9sOmxclP
	1MV/c6/dWheyrFjw42WPzX+CX3NsEfE/ZHPIqkhEbWXGHpkWDg+P6XySjFKy7tmMFgXap9uO
	C+n5LRAxfJreNUtxttxGh+KbToUbnvBtcmauaY7czTphzSMlluKMREMt5qLiRACl1OQpBAMA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQV0767/BBv8/KFocvF9v0XblILtF
	8+L1bBZdq3eyWFxeeInVonfBVTaLC0972Cwu75rDZjHj/D4mi0XLWpktmjdNYbU4s+oWu8WE
	3xfYHHg9Hkz9z+SxeM9LJo95JwM99s9dw+4x++4PRo++LasYPY7f2M7k8XmTXABHVAOjTUZq
	YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QyUoKZYk5pUCh
	gMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMWLvjEWbPaumHC8pIFxvm0XIyeHhICJ
	xOnlu5khbDGJC/fWs3UxcnEICUxnlGh6/okFwvnNKHHk9ntGkCo2ATWJL18Os4PYIgIeEneP
	LQezmQV2MEnsnZUF0dDOKLFp+WE2kASngKfEnfXfwIqEBaIlFt5czgpiswioSrzfeABsNa+A
	rcT7iX9ZIGxBiR+T77FADNWSWL/zOBOELS+xec1boHoOoFPVJR791QUxRQSMJHas8YaoEJHY
	9+Id4wRGoVlIBs1CMmgWkkGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGccJ5J
	7WBc2WBxiFGAg1GJh/fjgj/BQqyJZcWVuYcYJTiYlUR4M43/BgvxpiRWVqUW5ccXleakFh9i
	NAX6cyKzlGhyPjAZ5pXEGxqbmBlZGplZGJmYmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRq
	YFzEpucv2LBEcL/9tXOaM3Wn7Au6F/hvh7Puy+eft926y6HD9vJqnUHQLb1v/vwtaaKhWx97
	7lnAei5o/gUWweJJp5g3s6wt3nj/GvuGHU2LVt/13mnKaHMkT/ZrmbbulNYGQ7/y32YtB+Nl
	WzvU9rLN9b+y0i8mbceaS+evsG//90nmD8d2Q2slluKMREMt5qLiRAD395uiTgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2014 11:55 PM, Vivek Gautam wrote:
> 
> Adding phy calibrate callback, which facilitates setting certain
> PHY settings post initialization of the PHY controller.
> Exynos5420 and Exynos5800 have 28nm USB 3.0 DRD PHY for which
> the Loss-of-Signal (LOS) Detector Threshold Level as well as
> Tx-Vboost-Level should be controlled for Super-Speed operations.
> 
> Additionally set proper time to wait for RxDetect measurement,
> for desired PHY reference clock, so as to solve issue with enumeration
> of few USB 3.0 devices, like Samsung SUM-TSB16S 3.0 USB drive
> on the controller.
> We are using CR_port for this purpose to send required data
> to override the LOS values.
> 
> On testing with USB 3.0 devices on USB 3.0 port present on
> SMDK5420, and peach-pit boards should see following message:
> usb 2-1: new SuperSpeed USB device number 2 using xhci-hcd
> 
> and without this patch, should see below shown message:
> usb 1-1: new high-speed USB device number 2 using xhci-hcd
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/phy/phy-exynos5-usbdrd.c |  169 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 169 insertions(+)
> 
> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
> index 47f47fe..fa13784 100644
> --- a/drivers/phy/phy-exynos5-usbdrd.c
> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> @@ -89,8 +89,20 @@
>  #define PHYCLKRST_COMMONONN			BIT(0)
> 
>  #define EXYNOS5_DRD_PHYREG0			0x14
> +
> +#define EXYNOS5_DRD_PHYREG0_SSC_REF_CLK_SEL	BIT(21)
> +#define EXYNOS5_DRD_PHYREG0_SSC_RANGE		BIT(20)
> +#define EXYNOS5_DRD_PHYREG0_CR_WRITE		BIT(19)
> +#define EXYNOS5_DRD_PHYREG0_CR_READ		BIT(18)
> +#define EXYNOS5_DRD_PHYREG0_CR_DATA_IN(_x)	((_x) << 2)
> +#define EXYNOS5_DRD_PHYREG0_CR_CAP_DATA		BIT(1)
> +#define EXYNOS5_DRD_PHYREG0_CR_CAP_ADDR		BIT(0)
> +
>  #define EXYNOS5_DRD_PHYREG1			0x18
> 
> +#define EXYNOS5_DRD_PHYREG1_CR_DATA_OUT(_x)	((_x) << 1)
> +#define EXYNOS5_DRD_PHYREG1_CR_ACK		BIT(0)
> +
>  #define EXYNOS5_DRD_PHYPARAM0			0x1c
> 
>  #define PHYPARAM0_REF_USE_PAD			BIT(31)
> @@ -118,6 +130,26 @@
>  #define EXYNOS5_DRD_PHYRESUME			0x34
>  #define EXYNOS5_DRD_LINKPORT			0x44
> 
> +/* USB 3.0 DRD PHY SS Function Control Reg; accessed by CR_PORT */
> +#define EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN		(0x15)
> +

Please remove unnecessary line.

> +#define LOSLEVEL_OVRD_IN_LOS_BIAS_5420			(0x5 << 13)
> +#define LOSLEVEL_OVRD_IN_LOS_BIAS_DEFAULT		(0x0 << 13)
> +#define LOSLEVEL_OVRD_IN_EN				(0x1 << 10)
> +#define LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT		(0x9 << 0)
> +
> +#define EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN	(0x12)
> +#define TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420		(0x5 << 13)
> +#define TX_VBOOSTLEVEL_OVRD_IN_VBOOST_DEFAULT		(0x4 << 13)
> +
> +#define EXYNOS5_DRD_PHYSS_LANE0_TX_DEBUG		(0x1010)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_19M2_20M		(0x4 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_24M		(0x8 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_25M_26M		(0x8 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_48M_50M_52M	(0x20 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_62M5		(0x20 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_96M_100M		(0x40 << 4)
> +
>  #define KHZ	1000
>  #define MHZ	(KHZ * KHZ)
> 
> @@ -135,12 +167,14 @@ struct exynos5_usbdrd_phy_config {
>  	void (*phy_isol)(struct phy_usb_instance *inst, u32 on);
>  	void (*phy_init)(struct exynos5_usbdrd_phy *phy_drd);
>  	unsigned int (*set_refclk)(struct phy_usb_instance *inst);
> +	int (*phy_calibrate)(struct phy_usb_instance *inst);
>  };
> 
>  struct exynos5_usbdrd_phy_drvdata {
>  	const struct exynos5_usbdrd_phy_config *phy_cfg;
>  	u32 pmu_offset_usbdrd0_phy;
>  	u32 pmu_offset_usbdrd1_phy;
> +	void (*calibrate)(struct exynos5_usbdrd_phy *phy_drd);
>  };
> 
>  /**
> @@ -487,6 +521,138 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
>  	return 0;
>  }
> 
> +static void crport_handshake(struct exynos5_usbdrd_phy *phy_drd,
> +						u32 val, u32 cmd)
> +{
> +	u32 usec = 100;
> +	u32 result;
> +
> +	writel(val | cmd, phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
> +
> +	do {
> +		result = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYREG1);
> +		if (result & EXYNOS5_DRD_PHYREG1_CR_ACK)
> +			break;
> +
> +		udelay(1);
> +	} while (usec-- > 0);
> +
> +	if (!usec)
> +		dev_err(phy_drd->dev,
> +			"CRPORT handshake timeout1 (0x%08x)\n", val);
> +
> +	usec = 100;
> +
> +	writel(val, phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
> +
> +	do {
> +		result = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYREG1);
> +		if (!(result & EXYNOS5_DRD_PHYREG1_CR_ACK))
> +			break;
> +
> +		udelay(1);
> +	} while (usec-- > 0);
> +
> +	if (!usec)
> +		dev_err(phy_drd->dev,
> +			"CRPORT handshake timeout2 (0x%08x)\n", val);
> +}
> +
> +static void crport_ctrl_write(struct exynos5_usbdrd_phy *phy_drd,
> +						u32 addr, u32 data)
> +{
> +	/* Write Address */
> +	crport_handshake(phy_drd, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(addr),
> +			 EXYNOS5_DRD_PHYREG0_CR_CAP_ADDR);

According to the guidance from H/W team, before calling crport_handshake(),
write access for EXYNOS5_DRD_PHYREG0 register is necessary.

Please, add the write access as follows.

+	/* Write Address */
+	writel(EXYNOS5_DRD_PHYREG0_CR_DATA_IN(addr),
+		phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
+	crport_handshake(phy_drd, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(addr),
+			 EXYNOS5_DRD_PHYREG0_CR_CAP_ADDR);

Best regards,
Jingoo Han

> +
> +	/* Write Data */
> +	crport_handshake(phy_drd, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(data),
> +			 EXYNOS5_DRD_PHYREG0_CR_CAP_DATA);
> +	crport_handshake(phy_drd, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(data),
> +			 EXYNOS5_DRD_PHYREG0_CR_WRITE);
> +}
> +
> +/*
> + * Override PHY paramaeters using CR_PORT register to calibrate settings
> + * to meet meet SuperSpeed requirements, on Exynos5420 and Exynos5800 systems,
> + * which have 28nm USB 3.0 DRD PHY.
> + */
> +static void exynos5420_usbdrd_phy_calibrate(struct exynos5_usbdrd_phy *phy_drd)
> +{
> +	u32 temp;
> +
> +	/*
> +	 * Change los_bias to (0x5) for 28nm PHY from a
> +	 * default value (0x0); los_level is set as default
> +	 * (0x9) as also reflected in los_level[30:26] bits
> +	 * of PHYPARAM0 register.
> +	 */
> +	temp = LOSLEVEL_OVRD_IN_LOS_BIAS_5420 |
> +		LOSLEVEL_OVRD_IN_EN |
> +		LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT;
> +	crport_ctrl_write(phy_drd,
> +			  EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN,
> +			  temp);
> +
> +	/*
> +	 * Set tx_vboost_lvl to (0x5) for 28nm PHY Tuning,
> +	 * to raise Tx signal level from its default value of (0x4)
> +	 */
> +	temp = TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420;
> +	crport_ctrl_write(phy_drd,
> +			  EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN,
> +			  temp);
> +
> +	/*
> +	 * Set proper time to wait for RxDetect measurement, for
> +	 * desired reference clock of PHY, by tuning the CRPORT
> +	 * register LANE0.TX_DEBUG which is internal to PHY.
> +	 * This fixes issue with few USB 3.0 devices, which are
> +	 * not detected (not even generate interrupts on the bus
> +	 * on insertion) without this change.
> +	 * e.g. Samsung SUM-TSB16S 3.0 USB drive.
> +	 */
> +	switch (phy_drd->extrefclk) {
> +	case EXYNOS5_FSEL_50MHZ:
> +		temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_48M_50M_52M;
> +		break;
> +	case EXYNOS5_FSEL_20MHZ:
> +	case EXYNOS5_FSEL_19MHZ2:
> +		temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_19M2_20M;
> +		break;
> +	case EXYNOS5_FSEL_24MHZ:
> +	default:
> +		temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_24M;
> +		break;
> +	}
> +
> +	crport_ctrl_write(phy_drd,
> +			  EXYNOS5_DRD_PHYSS_LANE0_TX_DEBUG,
> +			  temp);
> +}
> +
> +/* Calibrate PIPE3 PHY settings, if any */
> +static int exynos5_usbdrd_pipe3_calibrate(struct phy_usb_instance *inst)
> +{
> +	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
> +
> +	/* Call respective phy_calibrate given by certain platform */
> +	if (phy_drd->drv_data->calibrate)
> +		phy_drd->drv_data->calibrate(phy_drd);
> +
> +	return 0;
> +}
> +
> +static int exynos5_usbdrd_phy_calibrate(struct phy *phy)
> +{
> +	struct phy_usb_instance *inst = phy_get_drvdata(phy);
> +
> +	if (inst->phy_cfg->phy_calibrate)
> +		inst->phy_cfg->phy_calibrate(inst);
> +
> +	return 0;
> +}
> +
>  static struct phy *exynos5_usbdrd_phy_xlate(struct device *dev,
>  					struct of_phandle_args *args)
>  {
> @@ -503,6 +669,7 @@ static struct phy_ops exynos5_usbdrd_phy_ops = {
>  	.exit		= exynos5_usbdrd_phy_exit,
>  	.power_on	= exynos5_usbdrd_phy_power_on,
>  	.power_off	= exynos5_usbdrd_phy_power_off,
> +	.calibrate	= exynos5_usbdrd_phy_calibrate,
>  	.owner		= THIS_MODULE,
>  };
> 
> @@ -518,6 +685,7 @@ static const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
>  		.phy_isol	= exynos5_usbdrd_phy_isol,
>  		.phy_init	= exynos5_usbdrd_pipe3_init,
>  		.set_refclk	= exynos5_usbdrd_pipe3_set_refclk,
> +		.phy_calibrate	= exynos5_usbdrd_pipe3_calibrate,
>  	},
>  };
> 
> @@ -525,6 +693,7 @@ static const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
>  	.phy_cfg		= phy_cfg_exynos5,
>  	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
>  	.pmu_offset_usbdrd1_phy	= EXYNOS5420_USBDRD1_PHY_CONTROL,
> +	.calibrate		= exynos5420_usbdrd_phy_calibrate,

Hmm, how about adding just flag for this, instead of function callback?
It looks a little bit confusing.

Best regards,
Jingoo Han

>  };
> 
>  static const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
> --
> 1.7.10.4
> 

