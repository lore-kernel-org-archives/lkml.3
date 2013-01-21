Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3AURou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:44:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2362 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3AURos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:44:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Jan 2013 09:44:28 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: DTS: harmony: enable keyboard
Date: Mon, 21 Jan 2013 23:14:05 +0530
Message-ID: <1358790245-21724-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable Tegra based keyboard interfacing for keys and provide
all key mapping through DTS file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Stephen,
Request you to give a try on this patch? The patch is generated based on seaboard
patch and downstream key mapping. I am expecting that it should work.
Sorry for troubling you again.
If this works then we are completely done with the KBC.

 arch/arm/boot/dts/tegra20-harmony.dts |  117 +++++++++++++++++++++++++++++++++
 1 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index b506de9..54295e3 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -448,6 +448,123 @@
 		bus-width = <8>;
 	};
 
+	kbc {
+		status = "okay";
+		nvidia,debounce-delay-ms = <2>;
+		nvidia,repeat-delay-ms = <160>;
+		nvidia,kbc-row-pins = <0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15>;
+		nvidia,kbc-col-pins = <16 17 18 19 20 21 22 23>;
+		linux,keymap = <0x00020011	/* KEY_W */
+				0x0003001F	/* KEY_S */
+				0x0004001E	/* KEY_A */
+				0x0005002C	/* KEY_Z */
+				0x000701D0	/* KEY_FN */
+				0x0107008B	/* KEY_MENU */
+				0x02060038	/* KEY_LEFTALT */
+				0x02070064	/* KEY_RIGHTALT */
+				0x03000006	/* KEY_5 */
+				0x03010005	/* KEY_4 */
+				0x03020013	/* KEY_R */
+				0x03030012	/* KEY_E */
+				0x03040021	/* KEY_F */
+				0x03050020	/* KEY_D */
+				0x0306002D	/* KEY_X */
+				0x04000008	/* KEY_7 */
+				0x04010007	/* KEY_6 */
+				0x04020014	/* KEY_T */
+				0x04030023	/* KEY_H */
+				0x04040022	/* KEY_G */
+				0x0405002F	/* KEY_V */
+				0x0406002E	/* KEY_C */
+				0x04070039	/* KEY_SPACE */
+				0x0500000A	/* KEY_9 */
+				0x05010009	/* KEY_8 */
+				0x05020016	/* KEY_U */
+				0x05030015	/* KEY_Y */
+				0x05040024	/* KEY_J */
+				0x05050031	/* KEY_N */
+				0x05060030	/* KEY_B */
+				0x0507002B	/* KEY_BACKSLASH */
+				0x0600000C	/* KEY_MINUS */
+				0x0601000B	/* KEY_0 */
+				0x06020018	/* KEY_O */
+				0x06030017	/* KEY_I */
+				0x06040026	/* KEY_L */
+				0x06050025	/* KEY_K */
+				0x06060033	/* KEY_COMMA */
+				0x06070032	/* KEY_M */
+				0x0701000D	/* KEY_EQUAL */
+				0x0702001B	/* KEY_RIGHTBRACE */
+				0x0703001C	/* KEY_ENTER */
+				0x0707008B	/* KEY_MENU */
+				0x0804002A	/* KEY_LEFTSHIFT */
+				0x08050036	/* KEY_RIGHTSHIFT */
+				0x0905001D	/* KEY_LEFTCTRL */
+				0x09070061	/* KEY_RIGHTCTRL */
+				0x0B00001A	/* KEY_LEFTBRACE */
+				0x0B010019	/* KEY_P */
+				0x0B020028	/* KEY_APOSTROPHE */
+				0x0B030027	/* KEY_SEMICOLON */
+				0x0B040035	/* KEY_SLASH */
+				0x0B050034	/* KEY_DOT */
+				0x0C000044	/* KEY_F10 */
+				0x0C010043	/* KEY_F9 */
+				0x0C02000E	/* KEY_BACKSPACE */
+				0x0C030004	/* KEY_3 */
+				0x0C040003	/* KEY_2 */
+				0x0C050067	/* KEY_UP */
+				0x0C0600D2	/* KEY_PRINT */
+				0x0C070077	/* KEY_PAUSE */
+				0x0D00006E	/* KEY_INSERT */
+				0x0D01006F	/* KEY_DELETE */
+				0x0D030068	/* KEY_PAGEUP */
+				0x0D04006D	/* KEY_PAGEDOWN */
+				0x0D05006A	/* KEY_RIGHT */
+				0x0D06006C	/* KEY_DOWN */
+				0x0D070069	/* KEY_LEFT */
+				0x0E000057	/* KEY_F11 */
+				0x0E010058	/* KEY_F12 */
+				0x0E020042	/* KEY_F8 */
+				0x0E030010	/* KEY_Q */
+				0x0E04003E	/* KEY_F4 */
+				0x0E05003D	/* KEY_F3 */
+				0x0E060002	/* KEY_1 */
+				0x0E070041	/* KEY_F7 */
+				0x0F000001	/* KEY_ESC */
+				0x0F010029	/* KEY_GRAVE */
+				0x0F02003F	/* KEY_F5 */
+				0x0F03000F	/* KEY_TAB */
+				0x0F04003B	/* KEY_F1 */
+				0x0F05003C	/* KEY_F2 */
+				0x0F06003A	/* KEY_CAPSLOCK */
+				0x0F070040	/* KEY_F6 */
+				0x14000047	/* KEY_KP7 */
+				0x15000049	/* KEY_KP9 */
+				0x15010048	/* KEY_KP8 */
+				0x1502004B	/* KEY_KP4 */
+				0x1504004F	/* KEY_KP1 */
+				0x1601004E	/* KEY_KPSLASH */
+				0x1602004D	/* KEY_KP6 */
+				0x1603004C	/* KEY_KP5 */
+				0x16040051	/* KEY_KP3 */
+				0x16050050	/* KEY_KP2 */
+				0x16070052	/* KEY_KP0 */
+				0x1B010037	/* KEY_KPASTERISK */
+				0x1B03004A	/* KEY_KPMINUS */
+				0x1B04004E	/* KEY_KPPLUS */
+				0x1B050053	/* KEY_KPDOT */
+				0x1C050073	/* KEY_VOLUMEUP */
+				0x1D030066	/* KEY_HOME */
+				0x1D04006B	/* KEY_END */
+				0x1D0500E1	/* KEY_BRIGHTNESSUP */
+				0x1D060072	/* KEY_VOLUMEDOWN */
+				0x1D0700E0	/* KEY_BRIGHTNESSDOWN */
+				0x1E000045	/* KEY_NUMLOCK */
+				0x1E010046	/* KEY_SCROLLLOCK */
+				0x1E020071	/* KEY_MUTE */
+				0x1F0400D6>;	/* KEY_QUESTION */
+	};
+
 	regulators {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
1.7.1.1

