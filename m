Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3CWGJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 02:09:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2522 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3CWGJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 02:09:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Mar 2013 23:08:55 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Sat, 23 Mar 2013 11:38:57 +0530
Subject: RE: PCIE: 32 bit prefetchable memory not getting programmed in BARs
Thread-Topic: PCIE: 32 bit prefetchable memory not getting programmed in BARs
Thread-Index: Ac4njHmF8T/hAtYUR2iBLbfkk/8kcgAAFFzg
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B375A1A0@BGMAIL01.nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

In my Graphics card, it has 4 memory requirement:

a. 32 bit non-prefetchable
b. 32 bit prefetchable
c. 64 bit non-prefetchable.
d. 64 bit prefetchable

And I see a is programmed in BAR0(offset 0x10), c in BAR3(offset 0x1C), d in BAR1(offset 0x14) but b is not programmed anywhere.

So is it  an expected behaviour? 

With best,
Jay


