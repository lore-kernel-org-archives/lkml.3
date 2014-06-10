Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbaFJChk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 22:37:40 -0400
Received: from cmta7.telus.net ([209.171.16.80]:33992 "EHLO cmta7.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933801AbaFJChh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 22:37:37 -0400
X-Authority-Analysis: v=2.0 cv=TdpIQ2sh c=1 sm=2
 a=zJWegnE7BH9C0Gl4FFgQyA==:17 a=JL14OfhZEkEA:10 a=LGgl8L9ij00A:10
 a=kj9zAlcOel0A:10 a=aatUQebYAAAA:8 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19
 a=danhDmx_AAAA:8 a=XroATJvq3ErZVRIY3nkA:9 a=CjuIK1q_8ugA:10 a=rtkDs-uTceoA:10
 a=xqhpnwvFvuMA:10 a=IjpP1gkeSWQA:10 a=zJWegnE7BH9C0Gl4FFgQyA==:117
X-Telus-Outbound-IP: 173.180.45.4
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Martin Steigerwald'" <Martin@lichtvoll.de>,
        <linux-kernel@vger.kernel.org>
Cc: <linux-pm@vger.kernel.org>
References: <1996399.buoKlNI5nG@merkaba> <13232691.DxAv2jorp8@merkaba> <4677478.c1YrKzctMH@merkaba>
In-Reply-To: <4677478.c1YrKzctMH@merkaba>
Subject: RE: [REGRESSION] 3.15: Seems to turbo mode Intel Sandybridge Dual Core without need, overheating CPU
Date: Mon, 9 Jun 2014 19:37:35 -0700
Message-ID: <003801cf8454$f0d84ba0$d288e2e0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+EK59pmt+uDYPuRIuHTp/y4UzP8QAJ9SnQ
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.06.08 14:42 Martin Steigerwald wrote:

> Its not just me:

> Please change intel_pstate default to disable
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1188647

That bug report is old, and made some sense at the time
it was entered.

Recent entries are all calling for it to be enabled by default again.

For my part of it, I was merely suggesting caution.

... Doug


