Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaHJIW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 04:22:59 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48167 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaHJIWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 04:22:55 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: mturquette@linaro.org, gabriel.fernandez@st.com
Cc: galak@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kiran.padwal21@gmail.com
Subject: [PATCH 1/3] clk: st: clkgen-mux: Make of_device_id array const
Date: Sun, 10 Aug 2014 13:52:19 +0530
Message-Id: <1407658939-1458-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 drivers/clk/st/clkgen-mux.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index 79dc40b..bed5ef8 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -341,7 +341,7 @@ static struct clkgena_divmux_data st_divmux_c32odf3 = {
 	.fb_start_bit_idx = 24,
 };
 
-static struct of_device_id clkgena_divmux_of_match[] = {
+static const struct of_device_id clkgena_divmux_of_match[] = {
 	{
 		.compatible = "st,clkgena-divmux-c65-hs",
 		.data = &st_divmux_c65hs,
@@ -479,7 +479,7 @@ static struct clkgena_prediv_data prediv_c32_data = {
 	.table = prediv_table16,
 };
 
-static struct of_device_id clkgena_prediv_of_match[] = {
+static const struct of_device_id clkgena_prediv_of_match[] = {
 	{ .compatible = "st,clkgena-prediv-c65", .data = &prediv_c65_data },
 	{ .compatible = "st,clkgena-prediv-c32", .data = &prediv_c32_data },
 	{}
@@ -586,7 +586,7 @@ static struct clkgen_mux_data stih407_a9_mux_data = {
 	.width = 2,
 };
 
-static struct of_device_id mux_of_match[] = {
+static const struct of_device_id mux_of_match[] = {
 	{
 		.compatible = "st,stih416-clkgenc-vcc-hd",
 		.data = &clkgen_mux_c_vcc_hd_416,
@@ -693,7 +693,7 @@ static struct clkgen_vcc_data st_clkgenf_vcc_416 = {
 	.lock = &clkgenf_lock,
 };
 
-static struct of_device_id vcc_of_match[] = {
+static const struct of_device_id vcc_of_match[] = {
 	{ .compatible = "st,stih416-clkgenc", .data = &st_clkgenc_vcc_416 },
 	{ .compatible = "st,stih416-clkgenf", .data = &st_clkgenf_vcc_416 },
 	{}
-- 
1.7.0.4

