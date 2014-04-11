Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaDKGFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:05:46 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:46708
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750909AbaDKGFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:05:45 -0400
From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: DL-MegaRAID Linux <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 30/55] scsi: Mark functions as static in
 megaraid/megaraid_sas_fp.c
Thread-Topic: [PATCH 30/55] scsi: Mark functions as static in
 megaraid/megaraid_sas_fp.c
Thread-Index: AQHPS3syNGqKniR2iEqVJGOTb+U8gZsMAPfQ
Date: Fri, 11 Apr 2014 06:05:23 +0000
Message-ID: <36fa759414a6439dac8b1c0b004324f6@DM2PR07MB400.namprd07.prod.outlook.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <89d00f872fc1f109e8ae1ca9172c37bb8dc909b4.1396114898.git.rashika.kheria@gmail.com>
In-Reply-To: <89d00f872fc1f109e8ae1ca9172c37bb8dc909b4.1396114898.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.19.224.250]
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(13464003)(189002)(199002)(51704005)(377454003)(74502001)(74662001)(31966008)(81342001)(81542001)(83322001)(19580405001)(19580395003)(33646001)(76482001)(76576001)(46102001)(99286001)(77982001)(79102001)(99396002)(20776003)(54356999)(76176999)(80022001)(87936001)(2656002)(74316001)(83072002)(4396001)(85852003)(80976001)(66066001)(86362001)(50986999)(92566001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR07MB397;H:DM2PR07MB400.namprd07.prod.outlook.com;FPR:8CAF585D.ACC28313.C9DC9132.8A3AAAEA.20390;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3B65qxp000692



>-----Original Message-----
>From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
>Sent: Saturday, March 29, 2014 11:48 PM
>To: linux-kernel@vger.kernel.org
>Cc: DL-MegaRAID Linux; James E.J. Bottomley; linux-scsi@vger.kernel.org;
>josh@joshtriplett.org
>Subject: [PATCH 30/55] scsi: Mark functions as static in
>megaraid/megaraid_sas_fp.c
>
>Mark functions as static in megaraid/megaraid_sas_fp.c because they are not
>used outside this file.
>
>This eliminates the following warning in megaraid/megaraid_sas_fp.c:
>drivers/scsi/megaraid/megaraid_sas_fp.c:80:5: warning: no previous
>prototype for â€˜mega_mod64â€™ [-Wmissing-prototypes]
>drivers/scsi/megaraid/megaraid_sas_fp.c:98:5: warning: no previous
>prototype for â€˜mega_div64_32â€™ [-Wmissing-prototypes]
>drivers/scsi/megaraid/megaraid_sas_fp.c:206:5: warning: no previous
>prototype for â€˜MR_GetSpanBlockâ€™ [-Wmissing-prototypes]
>drivers/scsi/megaraid/megaraid_sas_fp.c:341:5: warning: no previous
>prototype for â€˜mr_spanset_get_span_blockâ€™ [-Wmissing-prototypes]
>drivers/scsi/megaraid/megaraid_sas_fp.c:582:4: warning: no previous
>prototype for â€˜get_armâ€™ [-Wmissing-prototypes]
>drivers/scsi/megaraid/megaraid_sas_fp.c:705:4: warning: no previous
>prototype for â€˜MR_GetPhyParamsâ€™ [-Wmissing-prototypes]
>drivers/scsi/megaraid/megaraid_sas_fp.c:1196:4: warning: no previous
>prototype for â€˜megasas_get_best_armâ€™ [-Wmissing-prototypes]
>
>Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>---
> drivers/scsi/megaraid/megaraid_sas_fp.c |   26 ++++++++++++++------------
> 1 file changed, 14 insertions(+), 12 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c
>b/drivers/scsi/megaraid/megaraid_sas_fp.c
>index e24b6eb..83d5f74 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
>@@ -77,7 +77,7 @@ static u8 mr_spanset_get_phy_params(struct
>megasas_instance *instance, u32 ld,  static u64 get_row_from_strip(struct
>megasas_instance *instance, u32 ld,
> 	u64 strip, struct MR_FW_RAID_MAP_ALL *map);
>
>-u32 mega_mod64(u64 dividend, u32 divisor)
>+static u32 mega_mod64(u64 dividend, u32 divisor)
> {
> 	u64 d;
> 	u32 remainder;
>@@ -95,7 +95,7 @@ u32 mega_mod64(u64 dividend, u32 divisor)
>  *
>  * @return quotient
>  **/
>-u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
>+static u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
> {
> 	u32 remainder;
> 	u64 d;
>@@ -203,7 +203,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance
>*instance)
> 	return 1;
> }
>
>-u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
>+static u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
> 		    struct MR_FW_RAID_MAP_ALL *map)
> {
> 	struct MR_SPAN_BLOCK_INFO *pSpanBlock = MR_LdSpanInfoGet(ld,
>map); @@ -338,7 +338,7 @@ static int getSpanInfo(struct
>MR_FW_RAID_MAP_ALL *map, PLD_SPAN_INFO ldSpanInfo)
> *    div_error	   - Devide error code.
> */
>
>-u32 mr_spanset_get_span_block(struct megasas_instance *instance,
>+static u32 mr_spanset_get_span_block(struct megasas_instance *instance,
> 		u32 ld, u64 row, u64 *span_blk, struct
>MR_FW_RAID_MAP_ALL *map)  {
> 	struct fusion_context *fusion = instance->ctrl_context; @@ -579,8
>+579,8 @@ static u32 get_arm_from_strip(struct megasas_instance
>*instance,  }
>
> /* This Function will return Phys arm */
>-u8 get_arm(struct megasas_instance *instance, u32 ld, u8 span, u64 stripe,
>-		struct MR_FW_RAID_MAP_ALL *map)
>+static u8 get_arm(struct megasas_instance *instance, u32 ld, u8 span,
>+		  u64 stripe, struct MR_FW_RAID_MAP_ALL *map)
> {
> 	struct MR_LD_RAID  *raid = MR_LdRaidGet(ld, map);
> 	/* Need to check correct default value */ @@ -702,10 +702,11 @@
>static u8 mr_spanset_get_phy_params(struct megasas_instance *instance,
>u32 ld,
> *    span          - Span number
> *    block         - Absolute Block number in the physical disk
> */
>-u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64
>stripRow,
>-		u16 stripRef, struct IO_REQUEST_INFO *io_info,
>-		struct RAID_CONTEXT *pRAID_Context,
>-		struct MR_FW_RAID_MAP_ALL *map)
>+static u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld,
>+			  u64 stripRow, u16 stripRef,
>+			  struct IO_REQUEST_INFO *io_info,
>+			  struct RAID_CONTEXT *pRAID_Context,
>+			  struct MR_FW_RAID_MAP_ALL *map)
> {
> 	struct MR_LD_RAID  *raid = MR_LdRaidGet(ld, map);
> 	u32         pd, arRef;
>@@ -1193,8 +1194,9 @@ mr_update_load_balance_params(struct
>MR_FW_RAID_MAP_ALL *map,
> 	}
> }
>
>-u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo, u8 arm,
>u64 block,
>-			u32 count)
>+static u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo,
>u8 arm,
>+			       u64 block,
>+			       u32 count)
> {
> 	u16     pend0, pend1;
> 	u64     diff0, diff1;
 
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

-Sumit
>--
>1.7.9.5
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
