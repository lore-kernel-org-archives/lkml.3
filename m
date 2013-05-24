Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942Ab3EXCkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 22:40:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33338 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab3EXCkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 22:40:47 -0400
X-AuditID: cbfee68f-b7f436d000000f81-ca-519ed3269a7d
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Jonathan Cameron'" <jic23@kernel.org>,
        "=?iso-8859-2?Q?'Micha=B3_Miros=B3aw'?=" <mirq-linux@rere.qmqm.pl>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] staging/iio/mxs-lradc: fix preenable for multiple
Date: Fri, 24 May 2013 11:40:37 +0900
Message-id: <000001ce5828$13103b10$3930b130$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zI121y/MCDV6/VLVY0sxt8aBpFZPF
	5V1z2Cy+PT/FaLFg4yNGB1aPTas62Txmte1j8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	lT8+sxQsEajoWfiYrYHxI28XIyeHhICJxP4HrewQtpjEhXvr2boYuTiEBJYxSizacJgRpujq
	5/nMILaQwHRGiWmNohD2X0aJo5dKQWw2AV2JY+u3sILYIgLeEqem/GIGGcQs0MoocW3+X6Yu
	Rg6gBm6J1c1BIDWcAjwS6/50gs0UFvCVmHvpExuIzSKgKjH15X9WkHJeATuJT/tNQcK8AoIS
	PybfYwEJMwvoSHydFAESZhbQlnjy7gJYtYSAusSjv7oQB1RIfFlylAWiRERi34t3jCDHSAhc
	Y5fY+fQKM8QmAYlvkw+xQPTKSmw6wAzxrKTEwRU3WCYwSsxCsngWwuJZSBbPQrJhASPLKkbR
	1ILkguKk9CJjveLE3OLSvHS95PzcTYyQqOzfwXj3gPUhxmSg7ROZpUST84FRnVcSb2hsZmRh
	amJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRodrb+xSEm8bXu6P
	YpjUKqksz/T79Kr/lRNCb6+rChMKyxSd7Wv5Z/WeiGk7lfj0O++uj/qYEa4nNKGznDVL0pFX
	RqB+Xf+EyF4lVUX9pTGzlvSdPXd7U6Jw3gqD1+8WTnOYXZu57WyGhJyGO6v+5DUhi/9+SZ5p
	e9nj8EtfpXxNNb/3bSUnlFiKMxINtZiLihMBoAq0U+ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQV21y/MCDe4fUrRY0sxt8aBpFZPF
	5V1z2Cy+PT/FaLFg4yNGB1aPTas62Txmte1j8+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjJU/PrMULBGo6Fn4mK2B8SNvFyMnh4SAicTVz/OZIWwx
	iQv31rOB2EIC0xklpjWKQth/GSWOXioFsdkEdCWOrd/CCmKLCHhLnJryC6iXi4NZoJVR4tr8
	v0xdjBxADdwSq5uDQGo4BXgk1v3pBJsvLOArMffSJ7D5LAKqElNf/mcFKecVsJP4tN8UJMwr
	ICjxY/I9FpAws4COxNdJESBhZgFtiSfvLoBVSwioSzz6qwtxQIXElyVHWSBKRCT2vXjHOIFR
	aBaSQbMQBs1CMmgWko4FjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj/pn0DsZVDRaH
	GAU4GJV4eGfozAsUYk0sK67MPcQowcGsJMJbGAYU4k1JrKxKLcqPLyrNSS0+xJgM9OVEZinR
	5HxgOsoriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbPnAka
	s6drXzCtiX3Pu0jh6QsZM+k9OXZNcdyuWuf/icy9Of3SDZ7nLulTu3ueh3pffvIoYaJuT3bd
	m1PJ9asnLO5vFKkrZnDbyPM34/+Bs5tOzHGVOfmbS0L8g2h8WoXlm4szY4yVNnl+2Pf0xpzK
	4/+Utgb9vBQYdbj7hFt1/7tcntiHtvuUWIozEg21mIuKEwFweW7mPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>"

commit c80712c793febdf1b13ad0e1c71a051e071b3fd8 upstream

This fixes 'preenable failed: -EINVAL' error when using this driver.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>"
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/staging/iio/adc/mxs-lradc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c
b/drivers/staging/iio/adc/mxs-lradc.c
index 55a459b..f5e9e55 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -693,7 +693,6 @@ static void mxs_lradc_trigger_remove(struct iio_dev
*iio)
 static int mxs_lradc_buffer_preenable(struct iio_dev *iio)
 {
 	struct mxs_lradc *lradc = iio_priv(iio);
-	struct iio_buffer *buffer = iio->buffer;
 	int ret = 0, chan, ofs = 0;
 	unsigned long enable = 0;
 	uint32_t ctrl4_set = 0;
@@ -701,7 +700,7 @@ static int mxs_lradc_buffer_preenable(struct iio_dev
*iio)
 	uint32_t ctrl1_irq = 0;
 	const uint32_t chan_value = LRADC_CH_ACCUMULATE |
 		((LRADC_DELAY_TIMER_LOOP - 1) <<
LRADC_CH_NUM_SAMPLES_OFFSET);
-	const int len = bitmap_weight(buffer->scan_mask,
LRADC_MAX_TOTAL_CHANS);
+	const int len = bitmap_weight(iio->active_scan_mask,
LRADC_MAX_TOTAL_CHANS);
 
 	if (!len)
 		return -EINVAL;
@@ -728,7 +727,7 @@ static int mxs_lradc_buffer_preenable(struct iio_dev
*iio)
 		lradc->base + LRADC_CTRL1 + STMP_OFFSET_REG_CLR);
 	writel(0xff, lradc->base + LRADC_CTRL0 + STMP_OFFSET_REG_CLR);
 
-	for_each_set_bit(chan, buffer->scan_mask, LRADC_MAX_TOTAL_CHANS) {
+	for_each_set_bit(chan, iio->active_scan_mask, LRADC_MAX_TOTAL_CHANS)
{
 		ctrl4_set |= chan << LRADC_CTRL4_LRADCSELECT_OFFSET(ofs);
 		ctrl4_clr |= LRADC_CTRL4_LRADCSELECT_MASK(ofs);
 		ctrl1_irq |= LRADC_CTRL1_LRADC_IRQ_EN(ofs);
-- 
1.7.9.5

