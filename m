Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaGVJCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:02:07 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:53932 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaGVJCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:02:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+32F8rquwkOgLrTwiMKF1-jxZcgRd_qojdzwm=i8UzFPH6myA@mail.gmail.com>
References: <CA+32F8pBBynVXTtwp28U0WDCEm9MN9aYywX8GLQJ7sr3hGM6GQ@mail.gmail.com>
	<CA+32F8rquwkOgLrTwiMKF1-jxZcgRd_qojdzwm=i8UzFPH6myA@mail.gmail.com>
Date: Tue, 22 Jul 2014 11:02:03 +0200
Message-ID: <CA+32F8qDvy+vCNtc+Yd0TYWraCUXWRYbRj6PPsdYQnyT9X3CRA@mail.gmail.com>
Subject: Re: Performance Impact of skb_segment Security Fix
From: Azqa Nadeem <11bscsanadeem@seecs.edu.pk>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi,

 I am a researcher at EPFL, Switzerland. I study software vulnerabilities
 with the aim of building better tools to protect developers against security
 bugs. Recently the skb_sgement() was patched
 (http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=1fd819ecb90cc9b822cd84d3056ddba315d3340f)
 fixing the CVE-2014-0131 vulnerability
 (http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-0131) in the Linux
 Kernel. I am interested in the performance implications of this patch; could
 you help me answering the following questions:

Do you think the bug fix for skb_segment() function can have any performance
 implications?  If so, how much will the added checks add to the run time of
 the function?
 Is skb_segment() function part of the core functionality of the software?
 What fraction of time is expected to be spent in this function?

 Your answers will help us to better characterize the trade offs between
 performance and security in popular software.

 --
 Regards,
 Azqa Nadeem
 Internee - Dependable Systems Lab
 EPFL, Switzerland
