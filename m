Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3ANNyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:54:05 -0500
Received: from nm17-vm1.bullet.mail.ird.yahoo.com ([77.238.189.206]:25340 "EHLO
	nm17-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209Ab3ANNyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:54:02 -0500
X-Yahoo-Newman-Id: 572681.19425.bm@smtp136.mail.ird.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: 8TawE34VM1m_6oVzfCnIxYDxoy_k8Z2CXlr9opd_T1puM8m
 yV2qEeI1f7n_lqJfFLA_EH3JeZ7qvhq8oYYdsdhQO.3UESuiMv5g2LJJf0Cl
 wL7Sl7RIKNlI.1cUTH1wCCg9Af_6c5J8nGq7S8LUqSWnezHqrm8LbPwgzonX
 sglvaflhlQ0xXT_zSj5_fQ_BfPnt04sFGKUaybXmTnWXL5nduP0vhIIU5UDi
 qPCgymlhtwKVh3AIx.WfldnIyR4Cm3kkk35RNy5MH9Ny.eUs6.UnP80Jtee3
 .3q81pltswpugKS15pOLKUYFehL5cVT8L7hAJSO79_achNPLS_3XvN4_nj2d
 vgzRLmmuMqp7wtzbjKMvnqjfQSQrvCKljXD9Lp2eS7R6ijm0HC1lM8PBp0R5
 _NP5eYgsVpUSNPO2hr7Zj5eZWHSDHAFUBzSPHLgJw.2ZiY3XBiowiveY8_p5
 7.czFUDJri67O4289N_bwLrADkPQHCR2vCQ0JYg--
X-Yahoo-SMTP: mOFZFAuswBAG4_8a4ZBj.Wmvw2Qxc4R7nmE-
From: Schrober <franzschrober@yahoo.de>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: checkpatch.pl "uninitialized value"
Date: Mon, 14 Jan 2013 14:53:55 +0100
Message-ID: <2048162.tOhpucSojB@bentobox>
User-Agent: KMail/4.8.4 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1358171107.15075.89.camel@thorin>
References: <8765116.NauFasYmb5@bentobox> <1358171107.15075.89.camel@thorin>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013 14:45:06 Bernd Petrovitsch wrote:
> on which file?
> If you would have added the command line to trivially reproduce that (or
> whatever you did to get it), people are more likely to look into it.

All input I've tried. So I thought it is not relevant here. But of course, 
here is a simple example:

./scripts/checkpatch.pl -f lib/decompress_bunzip2.c
-- 
Franz Schrober
