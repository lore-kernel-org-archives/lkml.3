Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3BHARa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:17:30 -0500
Received: from nm20.bullet.mail.bf1.yahoo.com ([98.139.212.179]:21539 "HELO
	nm20.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751542Ab3BHARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:17:30 -0500
X-Yahoo-Newman-Id: 72241.92420.bm@smtp101.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yMFGUIAVM1nYZsSeOJEcDV5mLZWjHNF9w.B3BRssS6Hdrf2
 AvvoE2i5gMTCtW9If4vrbkgBJ_e9G1RN3pvVE.YGpF9k1APeusQ1wGMecQOB
 DeMJ5tmLdCxyNIk_InmHTyIbnb.XWv0tnXziuq.ndPJlOUX6DdXmP8KhjMkr
 HaxbwWCJAay9fJuIqnNvEf_nX4WGnL.22l9KFVtHC2dlo52Q3QReBjLHZ7HT
 MXvpKiL3mV7b.2QKV.LRZ6pT2kcTJZG1OCnZZWO4g6DNDGLniMCJMvOdjchM
 INhThu3z0M0QvrPfohZWphG1J_uovD_tOG.d.5da_VgqxTlzp.2CKK1LZE.J
 MVti.uk4pKCX7JbstfTvE30w2ZaFXB.DckoVcUe.3FId1T9t0D8qnYHDsAVW
 n5ZCcrDJiNAVc0A9ClsvWL4aH8Q2nnA.Yj2aLzTTSvzzWO.pUkvEMzxYGBqd
 ERgQq62klXCv8Vlhp
X-Yahoo-SMTP: izt95ZKswBDBT1bN16dPvD5jLHMKn5IFkJA-
Subject: Re: SATA error initializing Marvell 88SX6081
From: "James C. Georgas" <james.georgas@yahoo.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Feb 2013 17:17:27 -0700
Message-ID: <1360282647.2235.2.camel@Rainsong>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When using the sata_mv driver, I can't see my drives.
> 
> The drives are SATA6Gbps.
> 
> The SATA card is a Supermicro AOC-SAT2-MV8 SATA3Gbps card with a
Marvell
> 88SX6081 chip onboard.

Never mind, old kernel. Fixed in 3.7.6. Sorry for the noise.

