Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3CGALZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:11:25 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:50605 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755242Ab3CGALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:11:24 -0500
Message-ID: <1362615081.28137.5.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: S3C24XX: drop "select MACH_N35"
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 01:11:21 +0100
In-Reply-To: <013a01ce1ac7$11b287d0$35179770$%kim@samsung.com>
References: <1362609234.28137.2.camel@x61.thuisdomein>
	 <013a01ce1ac7$11b287d0$35179770$%kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2013 00:11:21.0973 (UTC) FILETIME=[4C829250:01CE1AC8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 09:02 +0900, Kukjin Kim wrote:

> BTW, so the machine type can be removed at arch/arm/tools/mach-types as well.

Well, that file has a big comment on top, containing the line:
    Please do not send patches to this file; it is automatically
generated!

So I didn't dare to touch it.


Paul Bolle

