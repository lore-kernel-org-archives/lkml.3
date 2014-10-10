Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaJJJz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:55:26 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60052 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751350AbaJJJzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:55:22 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Dave Young'" <dyoung@redhat.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: nf_reject_ipv4: module license 'unspecified' taints kernel
Thread-Topic: nf_reject_ipv4: module license 'unspecified' taints kernel
Thread-Index: AQHP5GsOoSOW+RbE+U2xQFgIZ6KzdpwpFmkg
Date: Fri, 10 Oct 2014 09:53:42 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174C8305@AcuExch.aculab.com>
References: <20141010091904.GD1981@darkstar.nay.redhat.com>
In-Reply-To: <20141010091904.GD1981@darkstar.nay.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young
> With today's linus tree, I got below kmsg:
> [   23.545204] nf_reject_ipv4: module license 'unspecified' taints kernel.
> [   23.551886] Disabling lock debugging due to kernel taint
...

Not 100% related, but why does loading a non-GPL module disable 
lock debugging?
(Is 'lock debugging' actually useful?)

	David



