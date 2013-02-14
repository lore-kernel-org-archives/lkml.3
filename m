Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754Ab3BNQ4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:56:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50878 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab3BNQ4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:56:10 -0500
MIME-Version: 1.0
Message-ID: <56c69426-968a-4d0b-a254-dd03456e30d3@default>
Date: Thu, 14 Feb 2013 08:56:01 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: RE: [PATCH] Various cleanups/fixes to zcache (v3).
References: <<1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>>
In-Reply-To: <<1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Subject: [PATCH] Various cleanups/fixes to zcache (v3).
> 
> From Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> # This line is ignored.
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Subject: [PATCH] Various cleanups/fixes to zcache (v3).
> In-Reply-To:
> 
> Hey Greg,
> 
> These patches do various cleanups of the zcache driver. The majority of the
> work is just to move all the different counters out to a debug file. The next
> step would be to figure out which ones are actually pertient and which can
> go under the knife. Oh, and also fix some of the compiler warnings.
> 
> This is based on top of ommit 76426daf50d5df38893cc189e9ccd026093debc8
> ("staging/zcache: Fix/improve zcache writeback code, tie to a config option")
> so should apply cleanly to your tree.
> 
> Please apply.

Useful cleanups.

Hopefully not too late for 3.9-rc0.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
