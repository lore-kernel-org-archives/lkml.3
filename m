Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007Ab3DBJMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:12:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40539 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247Ab3DBJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:12:43 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-b2-515aa1096aa3
Date: Tue, 02 Apr 2013 09:12:41 +0000 (GMT)
From: PADMAVATHI VENNA <padma.v@samsung.com>
Subject: Re: Re: [PATCH 2/2] dma: pl330: Use the generic of_dma_xlate_by_chan_id
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: padma.v@samsung.com
MIME-version: 1.0
X-MTR: 20130402085025468@padma.v
Msgkey: 20130402085025468@padma.v
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130402085025468@padma.v
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <26789240.182151364893959039.JavaMail.weblogic@epv6ml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42JZI2JSpcu5MCrQ4O5zMYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWx731qwTetin9ftrM2MD7R7GLk5BASUJI4da6dHcSWEDCRWLhm
	DROELSZx4d56ti5GLqCapYwSH/6tYoMp2vvtGSNEYj6jxPElR4ESHBwsAioS6+YKgtSwCehK
	/DvzH2yosECAxNQzl8FsEQEtiRuNbcwgNrPAGkaJv6dKII6Qlfj1bwlYnFdAUOLkzCcsELsU
	JKbPvcUCEVeUaL3SwQgRl5NYMvUy1KG8EjPan7LAxKd9XcMMYUtLnJ+1gRHmmcXfH0PF+SWO
	3d7BBHIySO+T+8EwY3Zv/gL1ogDQyQehWlUl1p68DjWeT2LNwrcsMGN2nVrODNN7f8tcJoi3
	FCWmdD9kh7ANJI4smsOK6i0OINtFYsUl6QmMyrOQZGYh6Z6FpBtZzQJGllWMoqkFyQXFSelF
	pnrFibnFpXnpesn5uZsYgSnh9L9nE3cw3j9gfYgxGRghE5mlRJPzgSklryTe0NjMyMLUxNTY
	yNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MhV1yLJ8vedXNfCQ6Rf5n
	SnjGSqXJv0XilQtfXpKbG7dcUOGzRuM5xkbTKw05W5a1pEp5702Zn7gjODdWpVosa0Ka/H8n
	QX7Z2eYn3fVutryw6OzgDmJJmZxtff3BfD+t664mT954fFn9pe/Yx6pqrVVeJ3f92pDI+W2m
	YXv80hBbFoMXx02UWIozEg21mIuKEwHhecqQHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsVy+t/t6bqcC6MCDR5u5be4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hqaxVoYGBkamQDUJaRn7
	3qcWfNOq+PdlO2sD4xPNLkZODiEBJYlT59rZQWwJAROJvd+eMULYYhIX7q1n62LkAqqZzyhx
	fMlRIIeDg0VARWLdXEGQGjYBXYl/Z/6D9QoLBEhMPXMZzBYR0JK40djGDGIzC6xhlPh7qgRi
	l6zEr39LwOK8AoISJ2c+YYHYpSAxfe4tFoi4okTrlQ6oG+Qklky9zARh80rMaH/KAhOf9nUN
	M4QtLXF+1ga4mxd/fwwV55c4dnsHE8jJIL1P7gfDjNm9+QsbhC0AdPJBqFZVibUnr0ON55NY
	s/AtC8yYXaeWM8P03t8ylwniLUWJKd0P2SFsA4kji+awonqLA8h2kVhxSXoCo9wsJJlZSLpn
	IelGVrOAkWUVo2hqQXJBcVJ6haFecWJucWleul5yfu4mRnBierZwB+OX89aHGAU4GJV4eB3m
	RAYKsSaWFVfmHmKU4GBWEuHdqhsVKMSbklhZlVqUH19UmpNafIgxGRh9E5mlRJPzgUkzryTe
	0NjE3NTY1MLA0NzcjDRhJXHep63WgUIC6YklqdmpqQWpRTBbmDg4pRoYOzXzXs8P23I6UPjB
	jKIiH54XBspLDTv49iw/wNHOM0O7l+H4g6VXRZVTMoV6bHO69v1LKff68zQkdGvyBMeHNYlM
	XrvmJ+y1/8GZve8KQ6jxEa4Pam8rlkTP+fh6nvEUzqU/u7wqf315/2TPv69rfx/xW/RZ3zfw
	rjUPi/CerE1qDzPdDi+KU2Ipzkg01GIuKk4EAHCu70SQAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r329D4Yv016490

Hi Lars,

------- Original Message -------
Sender : Lars-Peter Clausen<lars@metafoo.de>
Date : Apr 02, 2013 16:33 (GMT+09:00)
Title : Re: [PATCH 2/2] dma: pl330: Use the generic of_dma_xlate_by_chan_id

On 04/02/2013 08:27 AM, PADMAVATHI VENNA wrote:
> 
> Hi,
> ------- Original Message -------
> Sender : Lars-Peter Clausen
> Date : Mar 25, 2013 22:16 (GMT+09:00)
> Title : [PATCH 2/2] dma: pl330: Use the generic of_dma_xlate_by_chan_id
> 
> Use the generic of_dma_xlate_by_chan_id xlate callback instead of a custom
> implementation.
> 
> There is one minor difference between the generic of_dma_xlate_by_chan_id
> function and the pl330 specific one. of_dma_xlate_by_chan_id only sets the
> DMA_SLAVE capability for the channel capability mask, while the pl330 driver
> additionally sets the DMA_CYCLIC capability. But since all pl330 channels which
> have the DMA_SLAVE capability set also have DMA_CYCLIC capability set both
> functions will have the same result.
> 
> I am not clear about the dma capabilities. Is it mentioned some where that if we set DMA_SLAVE capability
> will that also set DMA_CYCLIC capability?
> 

Well DMA_SLAVE won't automatically set DMA_CYCLIC. But the driver sets both.

I tested your patches, it's woking for audio. But I need some clarification related to capabilities.
As per my understanding, controller driver registers the available capabilities in the probe and 
client drivers requests for a particular capability. In both the cases, in the dmaengine it checks
if the requested capability is satisfied.
If we don't set the DMA_CYCLIC, how __dma_device_satisfies_mask works?

 Please correct me if I am wrong.

Thanks
Padma
- Lars

> Signed-off-by: Lars-Peter Clausen 
> ---
> drivers/dma/pl330.c | 41 +----------------------------------------
> 1 file changed, 1 insertion(+), 40 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 345e2a1..ea48de7 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -608,11 +608,6 @@ struct dma_pl330_desc {
> struct dma_pl330_chan *pchan;
> };
> 
> -struct dma_pl330_filter_args {
> - struct dma_pl330_dmac *pdmac;
> - unsigned int chan_id;
> -};
> -
> static inline void _callback(struct pl330_req *r, enum pl330_op_err err)
> {
> if (r && r->xfer_cb)
> @@ -2358,16 +2353,6 @@ static void dma_pl330_rqcb(void *token, enum pl330_op_err err)
> tasklet_schedule(&pch->task);
> }
> 
> -static bool pl330_dt_filter(struct dma_chan *chan, void *param)
> -{
> - struct dma_pl330_filter_args *fargs = param;
> -
> - if (chan->device != &fargs->pdmac->ddma)
> - return false;
> -
> - return (chan->chan_id == fargs->chan_id);
> -}
> -
> bool pl330_filter(struct dma_chan *chan, void *param)
> {
> u8 *peri_id;
> @@ -2380,30 +2365,6 @@ bool pl330_filter(struct dma_chan *chan, void *param)
> }
> EXPORT_SYMBOL(pl330_filter);
> 
> -static struct dma_chan *of_dma_pl330_xlate(struct of_phandle_args *dma_spec,
> - struct of_dma *ofdma)
> -{
> - int count = dma_spec->args_count;
> - struct dma_pl330_dmac *pdmac = ofdma->of_dma_data;
> - struct dma_pl330_filter_args fargs;
> - dma_cap_mask_t cap;
> -
> - if (!pdmac)
> - return NULL;
> -
> - if (count != 1)
> - return NULL;
> -
> - fargs.pdmac = pdmac;
> - fargs.chan_id = dma_spec->args[0];
> -
> - dma_cap_zero(cap);
> - dma_cap_set(DMA_SLAVE, cap);
> - dma_cap_set(DMA_CYCLIC, cap);
> -
> - return dma_request_channel(cap, pl330_dt_filter, &fargs);
> -}
> -
> static int pl330_alloc_chan_resources(struct dma_chan *chan)
> {
> struct dma_pl330_chan *pch = to_pchan(chan);
> @@ -2996,7 +2957,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
> pi->pcfg.num_peri, pi->pcfg.num_events);
> 
> ret = of_dma_controller_register(adev->dev.of_node,
> - of_dma_pl330_xlate, pdmac);
> + of_dma_xlate_by_chan_id, pd);
> if (ret) {
> dev_err(&adev->dev,
> "unable to register DMA to the generic DT DMA helpers\n");ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
