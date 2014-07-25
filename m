Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbaGYLCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:02:54 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:36845 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaGYLCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:02:52 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-next <linux-next@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        lkml <linux-kernel@vger.kernel.org>,
        greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: ARC fails to boot on linux-next of 20140711
Thread-Topic: ARC fails to boot on linux-next of 20140711
Thread-Index: Ac+n9/VvPLYBeiFmRXu9blpBGqzWeQ==
Date: Fri, 25 Jul 2014 11:02:45 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C4B67CF@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

linux-next has a series for arc_uart (via tty tree) which converts it to generic
earlycon and specifies console via /chosen/stdout-path vs.  an explicit param in
/chose/bootargs

2014-06-24 9da433c0a0b5 ARC: [arcfpga] stdout-path now suffices for earlycon/console 

This relied on prev commit of yours (from linux next of 20140711), which seem to
have disappeared now.

2014-03-27 a9296cf2d0b6 of: Create of_console_check() for selecting a console
specified in /chosen 
2014-03-27 cfa9cacc5dd3 of: Enable console on serial ports specified by
/chosen/stdout-path 

Is there a specific reason for dropping these patches (or perhaps a merge to be
merged). I cherry-picked both but still doesn't work.

Can you please advise next step forward, before I go off debugging with those
patches in.

Thx,
-Vineet
