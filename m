Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaEVLgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:36:12 -0400
Received: from sam.nabble.com ([216.139.236.26]:39332 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbaEVLgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:36:11 -0400
Date: Thu, 22 May 2014 04:36:10 -0700 (PDT)
From: Varka Bhadram <varkab@cdac.in>
To: linux-kernel@vger.kernel.org
Message-ID: <1400758570637-865741.post@n7.nabble.com>
In-Reply-To: <1400733902089-865529.post@n7.nabble.com>
References: <1400733902089-865529.post@n7.nabble.com>
Subject: Re: [OMAP-Serial] omap ttyO2 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Finally i found the solution. This is the problem with device tree aliases
of uart in am33xx.dtsi

i changed uart0 to uart1 in all the DTS files , then its working fine.

previously i am loading the overlay with diffrent aliase name, because of
this the driver is not able to map the uart pins correctly,


Thanks and Regards,
Varka Bhadram



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/OMAP-Serial-omap-ttyO2-problem-tp865529p865741.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
