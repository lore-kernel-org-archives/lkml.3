Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaATLFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:05:14 -0500
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:1863
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaATLFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:05:06 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>
Subject: RE: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHPE1IcCA6lalTOXEyjRgC6v+JOLpqNPxeAgAAUL1CAAAwNgIAAEZOQ
Date: Mon, 20 Jan 2014 11:05:03 +0000
Message-ID: <f173c2531461478899818365e06df437@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1389938684-29467-1-git-send-email-b35083@freescale.com>
 <1389938684-29467-3-git-send-email-b35083@freescale.com>
 <20140120074019.GF26823@intel.com>
 <43d79ce905e24e9bb58ef49ac19db7d7@BL2PR03MB467.namprd03.prod.outlook.com>
 <20140120093541.GX26823@intel.com>
In-Reply-To: <20140120093541.GX26823@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(13464003)(377454003)(189002)(199002)(51704005)(81342001)(19580405001)(83322001)(80976001)(56816005)(76576001)(76796001)(81542001)(63696002)(33646001)(51856001)(81686001)(76786001)(85306002)(83072002)(85852003)(19580395003)(4396001)(77982001)(53806001)(56776001)(79102001)(47976001)(54356001)(49866001)(87266001)(59766001)(47736001)(66066001)(2656002)(65816001)(74876001)(76482001)(92566001)(69226001)(93136001)(90146001)(74316001)(81816001)(46102001)(50986001)(74502001)(80022001)(87936001)(93516002)(551934002)(74366001)(47446002)(54316002)(74662001)(74706001)(31966008)(86362001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB210;H:BL2PR03MB467.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0KB5JOr003019



> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: Monday, January 20, 2014 5:36 PM
> To: Lu Jingchang-B35083
> Cc: dan.j.williams@intel.com; arnd@arndb.de; shawn.guo@linaro.org;
> pawel.moll@arm.com; mark.rutland@arm.com; swarren@wwwdotorg.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org; Wang Huan-B18965
> Subject: Re: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
> 
> On Mon, Jan 20, 2014 at 09:06:43AM +0000, Jingchang Lu wrote:
> >
> >
> > > -----Original Message-----
> > > From: Vinod Koul [mailto:vinod.koul@intel.com]
> > > Sent: Monday, January 20, 2014 3:40 PM
> > > To: Lu Jingchang-B35083
> > > Cc: dan.j.williams@intel.com; arnd@arndb.de; shawn.guo@linaro.org;
> > > pawel.moll@arm.com; mark.rutland@arm.com; swarren@wwwdotorg.org;
> linux-
> > > kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> > > devicetree@vger.kernel.org; Wang Huan-B18965
> > > Subject: Re: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver
> support
> > >
> > > On Fri, Jan 17, 2014 at 02:04:44PM +0800, Jingchang Lu wrote:
> > > > Add Freescale enhanced direct memory(eDMA) controller support.
> > > > This module can be found on Vybrid and LS-1 SoCs.
> > > >
> > > > Signed-off-by: Alison Wang <b18965@freescale.com>
> > > > Signed-off-by: Jingchang Lu <b35083@freescale.com>
> > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > ---
> > >
> > > > +static int fsl_edma_control(struct dma_chan *chan, enum
> dma_ctrl_cmd
> > > cmd,
> > > > +		unsigned long arg)
> > > > +{
> > > > +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> > > > +	struct dma_slave_config *cfg = (void *)arg;
> > > > +	unsigned long flags;
> > > > +	LIST_HEAD(head);
> > > > +
> > > > +	switch (cmd) {
> > > > +	case DMA_TERMINATE_ALL:
> > > > +		spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> > > > +		fsl_edma_disable_request(fsl_chan);
> > > > +		fsl_chan->edesc = NULL;
> > > > +		vchan_get_all_descriptors(&fsl_chan->vchan, &head);
> > > > +		spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
> > > > +		vchan_dma_desc_free_list(&fsl_chan->vchan, &head);
> > > > +		return 0;
> > > well what happens to the current ongoing transactions, i don't see
> those
> > > getting
> > > terminated?
> > The fsl_edma_disable_request(fsl_chan) would end the channel's ongoing
> transaction, then
> > the eDMA would not response to device dma request, and the
> vchan_dma_desc_free_list()
> > will release all associate memory. Thanks.
> Can you explain a bit more how terminate will happen, given taht you are
> using
> same thing for pause?
It works just like an interrupt controller on irq enable and disable. It has a register called
set/clear enable request register(SERQ/CERQ) to enable or disable the DMA request for a given
channel. It won't transfer data any more with the enable request register cleared. So for the
pause and terminate the pause is the same. And there is no other way to stop the channels.
Thanks.



> > > > +static struct dma_async_tx_descriptor *fsl_edma_prep_dma_cyclic(
> > > > +		struct dma_chan *chan, dma_addr_t dma_addr, size_t
> buf_len,
> > > > +		size_t period_len, enum dma_transfer_direction
> direction,
> > > > +		unsigned long flags, void *context)
> > > > +{
> > > you may want to implement the capablities api subsequently for audio
> > > usage.
> > Do you mean the device_slave_caps function? If it is, I will add it.
> Yes, that can be incrementally added..
I have send the v11 patch out with a basic device_slave_caps definition. I notice
that there is some new update of the dma capabilities, so if possible and others ok,
could you please merge this patch first and leave me improving the driver in subsequent
patches. Thanks.


Best Regards,
Jingchang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
