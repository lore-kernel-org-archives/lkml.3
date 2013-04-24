Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3DXSBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:01:12 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.206]:51425 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883Ab3DXSBJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:01:09 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Apr 2013 14:01:09 EDT
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1366826050!12885961!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Apr 2013 12:53:42 -0500
Subject: RE: linux-next: build failure after merge of the final tree
 (staging tree related))
Thread-Topic: linux-next: build failure after merge of the final tree
 (staging tree related))
Thread-Index: Ac5AwS+Im4J1Uz3gQua/5WRHXt+YGgAUW7Rg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021D451A3BC3@AUSP01VMBX24.collaborationhost.net>
References: <20130424175600.df4a7e5307ea813e3afe73ea@canb.auug.org.au>
In-Reply-To: <20130424175600.df4a7e5307ea813e3afe73ea@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 24, 2013 12:56 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:

Ugh.. powerpc probably has CONFIG_ISA_DMA_API but not
CONFIG_VIRT_TO_BUS.

I'm looking for a fix now.

Regards,
Hartley

