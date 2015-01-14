Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbbANPLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:11:55 -0500
Received: from skprod3.natinst.com ([130.164.80.24]:46802 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754130AbbANPLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:11:53 -0500
From: "Brad Mouring" <bmouring@ni.com>
Date: Wed, 14 Jan 2015 09:11:49 -0600
To: David Miller <davem@davemloft.net>
Cc: xander.huff@ni.com, nicolas.ferre@atmel.com, jaeden.amero@ni.com,
        rich.tollerton@ni.com, ben.shelton@ni.com, brad.mouring@ni.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/macb: Adding comments to various #defs to make
 interpretation easier
Message-ID: <20150114151148.GA13853@linuxgetsreal>
References: <1421187351-27279-1-git-send-email-xander.huff@ni.com>
 <20150114.002609.1903467089677912749.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20150114.002609.1903467089677912749.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/14/2015 09:11:50 AM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/14/2015 09:11:50 AM,
	Serialize complete at 01/14/2015 09:11:50 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_05:2015-01-14,2015-01-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 12:26:09AM -0500, David Miller wrote:
> From: Xander Huff <xander.huff@ni.com>
> Date: Tue, 13 Jan 2015 16:15:50 -0600
> 
> > This change is to help improve at-a-glace knowledge of the purpose of the
> > various Cadence MACB/GEM registers. Comments are more helpful for human
> > readability than short acronyms.
> > 
> > Describe various #define varibles Cadence MACB/GEM registers as documented
> > in Xilinix's "Zynq-7000 All Programmable SoC TechnicalReference Manual, v1.9.1
s/Xilinix/Xilinx/. Sorry for the previous html-spam. Didn't follow the rule to always get coffee in the system prior to responding.
> > (UG-585)"
> > 
> > Signed-off-by: Xander Huff <xander.huff@ni.com>
> 
> Applied.
