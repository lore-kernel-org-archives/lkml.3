Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaJOJ3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:29:09 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:45166 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaJOJ3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:29:06 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>,
        Igor Guryanov <Igor.Guryanov@synopsys.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: ARC backport for stable 3.14
Thread-Topic: ARC backport for stable 3.14
Thread-Index: Ac/oWii1pua5fC5tRwaTyL4nf1liCQ==
Date: Wed, 15 Oct 2014 09:26:55 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C5E6418@IN01WEMBXA.internal.synopsys.com>
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

Can you please apply the following mainline commits to 3.14 stable (in the order below)

c3441edd2dea ARC: [SMP] General Fixes
d75386363ee6 ARC: fix mmuv2 warning
ef680cdc2437 ARC: Disable caches in early boot if so configured

Build/run tested on 3.14

Thx,
-Vineet
