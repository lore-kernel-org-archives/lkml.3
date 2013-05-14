Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3ENIx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:53:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43748 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab3ENIxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:53:20 -0400
X-AuditID: cbfee690-b7efc6d000006d92-bf-5191fb7cf603
Date: Tue, 14 May 2013 08:53:16 +0000 (GMT)
From: PADMAVATHI VENNA <padma.v@samsung.com>
Subject: Re: [PATCH resend 2/2] dma: pl330: Use the common
 of_dma_xlate_by_chan_id
To: Lars-Peter Clausen <lars@metafoo.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Jon Hunter <jon-hunter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: padma.v@samsung.com
MIME-version: 1.0
X-MTR: 20130514084037912@padma.v
Msgkey: 20130514084037912@padma.v
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130514084037912@padma.v
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <23087644.68271368521594139.JavaMail.weblogic@epv6ml09>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSpVv7e2Kgwa4LzBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjzdQNTAUPFCpO7XvJ3sD4Qb6LkZNDSEBJ4tS5dvYuRg4OCQET
	iZ8PzUDCEgJiEhfurWfrYuQCKlnKKDHnbwsLRMJEYvPJ40wQifmMElsXbmcHSbAIqEqcXrSe
	EcRmE9CV+HfmP1hcWCBI4v/1xawgtohAocS//R+ZQZqZBToYJS519DNBXCEr8evfEmYQm1dA
	UOLkzCdQ2xQk+np/M0HEFSXu/d4JFZeTWDL1MhOEzSsxo/0pXHza1zXMELa0xPlZGxhh3ln8
	/TFUnF/i2O0dTBAf80o8uR8MM2b35i9sELaAxNQzB6FaVSV2z1/DDmHzSaxZ+JYFZsyuU8uZ
	YXrvb5kLdg4z0JlTuh+yQ9gGEkcWzWFF9xavgLPEi/dnmSYwKs9CkpqFpH0WknZkNQsYWVYx
	iqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBCaG0/+eTdjBeO+A9SHGZGCcTGSWEk3OByaWvJJ4
	Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwWkr1S3sZ
	G0YI+chWMKhZx//3PfEy6fftKw5Tyqr7W/MnlnydtrxAWjxT4NRExXOsv3nmnfss5GHJvvL2
	pdzajdYd6y0/+T28u7mudjoPx4EHU2/n1Fhlrai4sWblIdnN1uLdx6eHbPfMsdEvP+i439w+
	NbJnR/k6C7YvWUbnNk0Mt9vue/SuEktxRqKhFnNRcSIAR3Lb3iIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2TN2a3xMDDbqmWlhc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q9NYK0MDAyNToJqEtIw1
	UzcwFTxQqDi17yV7A+MH+S5GTg4hASWJU+fa2UFsCQETic0njzNB2GISF+6tZ+ti5AKqmc8o
	sXXhdrAiFgFVidOL1jOC2GwCuhL/zvwHiwsLBEn8v76YFcQWESiU+Lf/IzNIM7NAB6PEpY5+
	JohtshK//i1hBrF5BQQlTs58wgKxTUGir/c3E0RcUeLe751QcTmJJVMvQ13EKzGj/SlcfNrX
	NcwQtrTE+VkbGGGuXvz9MVScX+LY7R1AvRxgvU/uB8OM2b35CxuELSAx9cxBqFZVid3z10AD
	gk9izcK3LDBjdp1azgzTe3/LXLBzmIHOnNL9kB3CNpA4smgOK7q3eAWcJV68P8s0gVFuFpLU
	LCTts5C0I6tZwMiyilE0tSC5oDgpvcJQrzgxt7g0L10vOT93EyM4QT1buIPxy3nrQ4wCHIxK
	PLwvf0wIFGJNLCuuzD3EKMHBrCTCu2bmxEAh3pTEyqrUovz4otKc1OJDjMnAGJzILCWanA9M
	nnkl8YbGJuamxqYWBobm5makCSuJ8z5ttQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMgQLxpwcM0v
	/pct/cHqu/fMF1r8vuvjg7IJ//ZcbbjqqVikM+uuat7V2Gpx10O7m2ax7hfZ1ts907lqusvU
	qysvN8zbK7Dny6+8lQ4TTp70Xpvd84w7fAb/5N3sqzw2HHu4dbYJw5bTu1gX7v9v88kpRMyg
	MvlsxPmlTZu0P8Y6/t8Y7Jw5L3ybEktxRqKhFnNRcSIARkfURZQDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4E8rXG8006317

Hi Lars,

As I remember Vinod had asked you to keep DMA_CYCLIC capability on both controller and client side.  But I didn't see in this patch set. 
Otherwise your patches looks good to me.

Thanks
Padma
------- Original Message -------
Sender : Lars-Peter Clausen<lars@metafoo.de>
Date : May 13, 2013 01:02 (GMT+09:00)
Title : [PATCH resend 2/2] dma: pl330: Use the common of_dma_xlate_by_chan_id

Use the generic of_dma_xlate_by_chan_id xlate callback instead of a custom
implementation.

There is one minor difference between the generic of_dma_xlate_by_chan_id
function and the pl330 specific one. of_dma_xlate_by_chan_id only sets the
DMA_SLAVE capability for the channel capability mask, while the pl330 driver
additionally sets the DMA_CYCLIC capability. But since all pl330 channels which
have the DMA_SLAVE capability set also have DMA_CYCLIC capability set both
functions will have the same result.

Signed-off-by: Lars-Peter Clausen 
---
drivers/dma/pl330.c | 41 +----------------------------------------
1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index a17553f..c831fae 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -608,11 +608,6 @@ struct dma_pl330_desc {
struct dma_pl330_chan *pchan;
};

-struct dma_pl330_filter_args {
- struct dma_pl330_dmac *pdmac;
- unsigned int chan_id;
-};
-
static inline void _callback(struct pl330_req *r, enum pl330_op_err err)
{
if (r && r->xfer_cb)
@@ -2358,16 +2353,6 @@ static void dma_pl330_rqcb(void *token, enum pl330_op_err err)
tasklet_schedule(&pch->task);
}

-static bool pl330_dt_filter(struct dma_chan *chan, void *param)
-{
- struct dma_pl330_filter_args *fargs = param;
-
- if (chan->device != &fargs->pdmac->ddma)
- return false;
-
- return (chan->chan_id == fargs->chan_id);
-}
-
bool pl330_filter(struct dma_chan *chan, void *param)
{
u8 *peri_id;
@@ -2380,30 +2365,6 @@ bool pl330_filter(struct dma_chan *chan, void *param)
}
EXPORT_SYMBOL(pl330_filter);

-static struct dma_chan *of_dma_pl330_xlate(struct of_phandle_args *dma_spec,
- struct of_dma *ofdma)
-{
- int count = dma_spec->args_count;
- struct dma_pl330_dmac *pdmac = ofdma->of_dma_data;
- struct dma_pl330_filter_args fargs;
- dma_cap_mask_t cap;
-
- if (!pdmac)
- return NULL;
-
- if (count != 1)
- return NULL;
-
- fargs.pdmac = pdmac;
- fargs.chan_id = dma_spec->args[0];
-
- dma_cap_zero(cap);
- dma_cap_set(DMA_SLAVE, cap);
- dma_cap_set(DMA_CYCLIC, cap);
-
- return dma_request_channel(cap, pl330_dt_filter, &fargs);
-}
-
static int pl330_alloc_chan_resources(struct dma_chan *chan)
{
struct dma_pl330_chan *pch = to_pchan(chan);
@@ -2989,7 +2950,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)

if (adev->dev.of_node) {
ret = of_dma_controller_register(adev->dev.of_node,
- of_dma_pl330_xlate, pdmac);
+ of_dma_pl330_xlate, pd);
if (ret) {
dev_err(&adev->dev,
"unable to register DMA to the generic DT DMA helpers\n");
-- 
1.8.0ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
