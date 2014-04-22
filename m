Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaDVLTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:19:18 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:15060
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932145AbaDVLTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:19:11 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I542I1432I1447Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h17326ah8275bh8275dh1de097h186068h1954cbhz2fh95h109h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: RE: [PATCH v7 1/2] can: xilinx CAN controller support
Thread-Topic: [PATCH v7 1/2] can: xilinx CAN controller support
Thread-Index: AQHPXgiZgKhFQ40Q102/VIe4iyjo45sdbrl4gAAMmXSAAAGVcA==
Date: Tue, 22 Apr 2014 11:18:48 +0000
References: <3e750ec3-9d47-4b4e-8173-56698ab19786@CH1EHSMHS029.ehs.local>
 <53562E7D.7090509@pengutronix.de>
 <957b07ca-f74c-47fb-963a-084710d48c5a@AM1EHSMHS014.ehs.local>
 <535643D9.3070601@pengutronix.de>
 <9f70ceca-c6fd-4d57-a54a-8cbf9d888137@CH1EHSMHS016.ehs.local>
 <53564E63.4010803@pengutronix.de>
In-Reply-To: <53564E63.4010803@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.45]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <b43293ed-5ecc-4d13-befd-651353fb79ba@CH1EHSMHS033.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3MBJOHh006412

Hi Marc,

> -----Original Message-----
> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> Sent: Tuesday, April 22, 2014 4:42 PM
> To: Appana Durga Kedareswara Rao
> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; Michal Simek; robh+dt@kernel.org;
> grant.likely@linaro.org; wg@grandegger.com
> Subject: Re: [PATCH v7 1/2] can: xilinx CAN controller support
>
> On 04/22/2014 01:08 PM, Appana Durga Kedareswara Rao wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> >> Sent: Tuesday, April 22, 2014 3:57 PM
> >> To: Appana Durga Kedareswara Rao; wg@grandegger.com; Michal Simek;
> >> grant.likely@linaro.org; robh+dt@kernel.org
> >> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> >> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> >> devicetree@vger.kernel.org
> >> Subject: Re: [PATCH v7 1/2] can: xilinx CAN controller support
> >>
> >> On 04/22/2014 12:06 PM, Appana Durga Kedareswara Rao wrote:
> >>
> >>>> Meanwhile Thomas Gleixner put some effort into the c_can driver and
> >>>> found some problems in most of the can driver. See comments inline.
> >>>>
> >>> Ok will look into that patches
> >>
> >> I've commented the relevant parts of your patch. Although more
> >> background information can be found in the c_can patches.
> >>
> > Ok
> >
> >>>>> +/**
> >>>>> + * xcan_tx_interrupt - Tx Done Isr
> >>>>> + * @ndev:  net_device pointer
> >>>>> + * @isr:   Interrupt status register value
> >>>>> + */
> >>>>> +static void xcan_tx_interrupt(struct net_device *ndev, u32 isr) {
> >>>>> +   struct xcan_priv *priv = netdev_priv(ndev);
> >>>>> +   struct net_device_stats *stats = &ndev->stats;
> >>>>> +
> >>>>> +   while (priv->tx_head - priv->tx_tail > 0) {
> >>>>> +           priv->write_reg(priv, XCAN_ICR_OFFSET,
> >>>> XCAN_IXR_TXOK_MASK);
> >>>>> +           if (!(isr & XCAN_IXR_TXOK_MASK))
> >>>>> +                   break;
> >>>>
> >>>> This looks broken. I assume you have to issue the
> >> XCAN_IXR_TXOK_MASK-
> >>>> write once per tx-completed CAN frame. If you enter this loop you
> >>>> write once, then isr is read, then you write again and may exit
> >>>> this loop if XCAN_IXR_TXOK_MASK is not set anymore.
> >>
> >> Let's assume you have put 3 CAN frames into the TX-queue and we're
> >> into tx-complete interrupt for the first frame and the other 2 are
> >> still not completed.
> >>
> >> This means the while() loop is not terminated by (priv->tx_head -
> >> priv->tx_tail > 0), as it can loop 3 times.
> >>
> >> What happens is:
> >>
> >> - priv->write_reg(priv, XCAN_ICR_OFFSET, XCAN_IXR_TXOK_MASK);
> >> - if (!(isr & XCAN_IXR_TXOK_MASK)) -> no break
> >> - can_get_echo_skb()
> >> - ...
> >> - isr = priv->read_reg(priv, XCAN_ISR_OFFSET);
> >> - loop ->
> >> - priv->write_reg(priv, XCAN_ICR_OFFSET, XCAN_IXR_TXOK_MASK);
> >> - if (!(isr & XCAN_IXR_TXOK_MASK)) -> break
> >>
> >> So you have 2x write_reg(priv, XCAN_ICR_OFFSET,
> XCAN_IXR_TXOK_MASK),
> >> but only a single TX completed CAN frame.
> >>
> >
> > Ok now got it :). Thanks for the explanation.
> > Will modify the loop logic like below.
> >
> > while (priv->tx_head - priv->tx_tail > 0) {
> >                  if ((isr & XCAN_IXR_TXOK_MASK)) {
> >                 priv->write_reg(priv, XCAN_ICR_OFFSET, XCAN_IXR_TXOK_MASK);
> >                         can_get_echo_skb(ndev, priv->tx_tail %
> >                                                 priv->tx_max);
> >                         priv->tx_tail++;
> >                         stats->tx_packets++;
> >                 } else {
> >                 break;
> >         }
> >
> >   }
> > Are you ok with this?
>
> what about this:
>
> while ((priv->tx_head - priv->tx_tail > 0) &&
>       (isr & XCAN_IXR_TXOK_MASK)) {
>
>       [...]
>
>       isr = priv->read_reg(priv, XCAN_ISR_OFFSET); }
>
> or even
>
> while ((priv->tx_head - priv->tx_tail > 0) &&
>       (priv->read_reg(priv, XCAN_ISR_OFFSET) & XCAN_IXR_TXOK_MASK))
> {
>
>       [...]
>
> }
Ok will use any one of the above.


Regards,
Kedar.

>
> Marc
>
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
