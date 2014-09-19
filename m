Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaISUxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:53:16 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:55917 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbaISUxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:53:14 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Take dwc2 driver through Felipe's tree?
Thread-Topic: Take dwc2 driver through Felipe's tree?
Thread-Index: Ac/US5KHRysMK3O7SAeZPU3kFvvLxQ==
Date: Fri, 19 Sep 2014 20:52:07 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844D9D41@US01WEMBX2.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

How would you feel about Felipe taking the dwc2 driver into his tree?
There has been quite a bit of increased activity with dwc2 lately, and
I know you already have more than enough stuff on your plate already.
So this would mean one less thing for you to worry about. Plus it
would mean an extra layer of review before getting to you.

I've already talked to Felipe about it, and he's fine with it. If
you're OK with it, I think I just need to send a patch adding a T:
line to the MAINTAINERS entry, showing Felipe's tree?

I guess we would want to do this just before you close your USB tree,
and you could announce it then?

-- 
Paul

