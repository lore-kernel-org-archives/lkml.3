Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3FQAsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:48:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16775 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3FQAsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:48:12 -0400
X-AuditID: cbfee68f-b7f436d000000f81-b3-51be5cca42cd
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Tony Lindgren'" <tony@atomide.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] arm: omap2: fix AM33xx hwmod infos for UART2
Date: Mon, 17 Jun 2013 09:48:09 +0900
Message-id: <000301ce6af4$570edf40$052c9dc0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkhkJMAQebi3wAAAo4zA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zA91TMfsCDc4e1bZY0sxtcXnXHDaL
	BRsfMVo8fdDEZLH/ipcDq8e3r5NYPJ5susjo0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkt
	3+8wFdzjrWh9soGlgXEDdxcjJ4eEgInEnten2CBsMYkL99YD2VwcQgLLGCVudx9i7GLkACta
	s5MTIr6IUeJAw3YmCOcvo8TOm6cZQbrZBHQljq3fwgpiiwh4S5ya8osZxGYWqJG4vPElC8gg
	IQFuidXNQSBhTgEeiXV/OsFKhAU8JD40fAQbwyKgKjHtahfYQbwCdhKN/U1QtqDEj8n3WCBG
	akms33mcCcKWl9i85i0zxJ3qEo/+6kJc0MMosX6qG0SJiMS+F+8YQU6WELjELtF+azoLxC4B
	iW+TD7FA9MpKbDrADAkHSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi4z1
	ihNzi0vz0vWS83M3MUIis38H490D1ocYk4HWT2SWEk3OB0Z2Xkm8obGZkYWpiamxkbmlGWnC
	SuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYRZ7s5Nm11ulNH9sClXXSubvy8h8q
	S2u8dF4V7vTLJD/6etHxjbfO65cwzr9uf0O0bp3IuhfLp3ZwLjohH1XjNU1Q5Nu3mRXONb8X
	cl6pPs/j/JunL47F/SHfIS62KeX1USl54rfCZietLJ+7OthU4c3quBPhaxS57i18wnXuR0/t
	zxuMbp84lViKMxINtZiLihMByxCmS+ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAd1TMfsCDZ7vUrdY0sxtcXnXHDaL
	BRsfMVo8fdDEZLH/ipcDq8e3r5NYPJ5susjo0bdlFaPH501yASxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGEdYwZLd/vMBXc461ofbKBpYFxA3cXIweHhICJxJqdnF2MnECm
	mMSFe+vZuhi5OIQEFjFKHGjYzgTh/GWU2HnzNCNIFZuArsSx9VtYQWwRAW+JU1N+MYPYzAI1
	Epc3vmQBGSokwC2xujkIJMwpwCOx7k8nWImwgIfEh4aPYGNYBFQlpl3tYgOxeQXsJBr7m6Bs
	QYkfk++xQIzUkli/8zgThC0vsXnNW2aIm9UlHv3Vhbigh1Fi/VQ3iBIRiX0v3jFOYBSahWTS
	LCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwXH/THoH46oGi0OMAhyM
	Sjy8EqJ7A4VYE8uKK3MPMUpwMCuJ8J6O2BcoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnA
	lJRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxCaqv/LgvT
	tL5QVcR06+av1gtPevq6EwzfZ26t4QjwW7zM9bO82Zc9Xx3Ez+RVLtjiu09CuEyt4EHwz22l
	c1oey9zIWLLvk+/L6+e23OZnEhFxuL1IYWl73zWHyW0Xpm3TD/y469qRtwq69242eqT+f/DS
	+vtq5qWGbP+uyipcSFqu+X2BnttHJZbijERDLeai4kQADdAAdD8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Thomas Petazzoni <thomas.petazzoni@free-electrons.com>"

commit 768dc16397fb18c9de209cbcb84d890b8279faa7 upstream

The UART2 hwmod structure is pointing to the EDMA channels of UART1,
which doesn't look right. This patch fixes this by making the UART2
hwmod structure to a new structure that lists the EDMA channels to be
used by the UART2.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
[paul@pwsan.com: updated to apply]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
index 26eee4a..6a57150 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
@@ -1979,6 +1979,13 @@ static struct omap_hwmod am33xx_uart1_hwmod = {
 	},
 };
 
+/* uart2 */
+static struct omap_hwmod_dma_info uart2_edma_reqs[] = {
+	{ .name = "tx",	.dma_req = 28, },
+	{ .name = "rx",	.dma_req = 29, },
+	{ .dma_req = -1 }
+};
+
 static struct omap_hwmod_irq_info am33xx_uart2_irqs[] = {
 	{ .irq = 73 + OMAP_INTC_START, },
 	{ .irq = -1 },
@@ -1989,7 +1996,7 @@ static struct omap_hwmod am33xx_uart2_hwmod = {
 	.class		= &uart_class,
 	.clkdm_name	= "l4ls_clkdm",
 	.mpu_irqs	= am33xx_uart2_irqs,
-	.sdma_reqs	= uart1_edma_reqs,
+	.sdma_reqs	= uart2_edma_reqs,
 	.main_clk	= "dpll_per_m2_div4_ck",
 	.prcm		= {
 		.omap4	= {
-- 
1.7.9.5

