Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaLWII5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:08:57 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:39859 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaLWIIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:08:55 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: stable 3.14 backport request for ARC
Thread-Topic: stable 3.14 backport request for ARC
Thread-Index: AdAeh6+mLpv4PnbzRoGUgoFr8v1s3Q==
Date: Tue, 23 Dec 2014 08:08:51 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BC9324@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you please backport the following mainline commits to 3.14 stable.

2014-02-07 ec7ac6afd07b ARC: switch to generic ENTRY/END assembler annotations
2014-04-18 64ee9f32c33c ARC: Delete stale barrier.h


Thx,
-Vineet
