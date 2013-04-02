Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806Ab3DBG1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:27:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17438 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760797Ab3DBG1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:27:48 -0400
X-AuditID: cbfee68d-b7f786d000005188-98-515a7a63fe15
Date: Tue, 02 Apr 2013 06:27:47 +0000 (GMT)
From: PADMAVATHI VENNA <padma.v@samsung.com>
Subject: Re: [PATCH 2/2] dma: pl330: Use the generic of_dma_xlate_by_chan_id
To: Lars-Peter Clausen <lars@metafoo.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Jon Hunter <jon-hunter@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: padma.v@samsung.com
MIME-version: 1.0
X-MTR: 20130402050049644@padma.v
Msgkey: 20130402050049644@padma.v
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130402050049644@padma.v
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <19148230.174331364884064812.JavaMail.weblogic@epv6ml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSrZtcFRVo8Oszh8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mr41+5asEGhYtHHZuYGxgPyXYycHEICShKnzrWzg9gSAiYSb760
	s0HYYhIX7q0HsrmAamYxSvQt7WGBKeqdsocdIjGfUeL2jMdMIAkWARWJGx1bmEFsNgFdiX9n
	/oNNFRbwkdh1+y8riC0iUCjxb/9HsBpmgVSJice+s0BcISvx698SsDivgKDEyZlPoJYpSPz+
	0MoEEVeU+H60Deo6OYklUy8zQdi8EjPan7LAxKd9XcMMYUtLnJ+1gRHmm8XfH0PF+SWO3d4B
	1MsB1vvkfjDMmN2bv0CNF5CYeuYgVKuqxKa+G9AA4pNYs/AtC8yYXaeWM8P03t8ylwniLUWJ
	Kd0P2SFsA4kji+awonqLA8h2kZg9M3cCo/IsJJlZSLpnIelGVrOAkWUVo2hqQXJBcVJ6kaFe
	cWJucWleul5yfu4mRmBSOP3vWe8OxtsHrA8xJgNjZCKzlGhyPjCp5JXEGxqbGVmYmpgaG5lb
	mpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB8aLupp0s/Q/+hKzhFN67uljz
	71tXodjUxbVPQ15Vz22V4Y6f9rNn8kaGfVrfZc2/7wv7zCO68HamqJHDH56QdjPzJj71ZxKm
	NvYFi1flanFM89Kym/tK39333smNzCmxMopFHHfuV26olfTg4/BPKFD/KN6zK/gWX6x7zxX7
	CV39shtrivSUWIozEg21mIuKEwGTWffgIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsVy+t/tGbrJVVGBBm/TLS7vmsPmwOjxeZNc
	AGNUmk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0Ewl
	hbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1StKG5kZ6RgZ6pkZ6haayVoYGBkSlQTUJaxr92
	14INChWLPjYzNzAekO9i5OQQElCSOHWunR3ElhAwkeidsgfKFpO4cG89WxcjF1DNfEaJ2zMe
	M4EkWARUJG50bGEGsdkEdCX+nfkP1iAs4COx6/ZfVhBbRKBQ4t/+j2A1zAKpEhOPfWeBWCYr
	8evfErA4r4CgxMmZT1gglilI/P7QygQRV5T4frSNDSIuJ7Fk6mUmCJtXYkb7UxaY+LSva5gh
	bGmJ87M2MMIcvfj7Y6g4v8Sx2zuAejnAep/cD4YZs3vzF6jxAhJTzxyEalWV2NR3A+p3Pok1
	C9+ywIzZdWo5M0zv/S1zmSDeUpSY0v2QHcI2kDiyaA4rqrc4gGwXidkzcycwys1CkpmFpHsW
	km5kNQsYWVYxiqYWJBcUJ6VXmOgVJ+YWl+al6yXn525iBCemZ0t2MDZcsD7EKMDBqMTDm8kV
	FSjEmlhWXJl7iFGCg1lJhHerLlCINyWxsiq1KD++qDQntfgQYzIw/iYyS4km5wOTZl5JvKGx
	ibmpsamFgaG5uRlpwkrivM9arQOFBNITS1KzU1MLUotgtjBxcEo1MLZ/4xWY31B6tpA3oV9X
	ZPHBZ3xFR/lm/uHv+8nsXHGcJWu6rIHApeNZ7TskQ1yN1j7akuafsOzBNd0HX/wlYlR/znG5
	2F3eJnrm36Pw6sLffUtE3E7lC/PaSLxI9ji8cInHIcZHhyxtZglbnq+ts6+U+9yrouWbVLpB
	+5PhKq0HV0ULeN6zK7EUZyQaajEXFScCABGPiUmQAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r326S5Ae015560


Hi,
------- Original Message -------
Sender : Lars-Peter Clausen<lars@metafoo.de>
Date : Mar 25, 2013 22:16 (GMT+09:00)
Title : [PATCH 2/2] dma: pl330: Use the generic of_dma_xlate_by_chan_id

Use the generic of_dma_xlate_by_chan_id xlate callback instead of a custom
implementation.

There is one minor difference between the generic of_dma_xlate_by_chan_id
function and the pl330 specific one. of_dma_xlate_by_chan_id only sets the
DMA_SLAVE capability for the channel capability mask, while the pl330 driver
additionally sets the DMA_CYCLIC capability. But since all pl330 channels which
have the DMA_SLAVE capability set also have DMA_CYCLIC capability set both
functions will have the same result.

I am not clear about the dma capabilities. Is it mentioned some where that if we set DMA_SLAVE capability
will that also set DMA_CYCLIC capability?

Signed-off-by: Lars-Peter Clausen 
---
drivers/dma/pl330.c | 41 +----------------------------------------
1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 345e2a1..ea48de7 100644
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
@@ -2996,7 +2957,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
pi->pcfg.num_peri, pi->pcfg.num_events);

ret = of_dma_controller_register(adev->dev.of_node,
- of_dma_pl330_xlate, pdmac);
+ of_dma_xlate_by_chan_id, pd);
if (ret) {
dev_err(&adev->dev,
"unable to register DMA to the generic DT DMA helpers\n");
-- 
1.8.0ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
