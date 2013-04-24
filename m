Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab3DXSel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:34:41 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.105]:43073 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757116Ab3DXSej convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:34:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1366828469!7273289!16
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Apr 2013 13:33:42 -0500
Subject: RE: linux-next: build failure after merge of the final tree
 (staging tree related))
Thread-Topic: linux-next: build failure after merge of the final tree
 (staging tree related))
Thread-Index: Ac5AwS+Im4J1Uz3gQua/5WRHXt+YGgAWO3uA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021D451A3BE8@AUSP01VMBX24.collaborationhost.net>
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
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
> drivers/staging/comedi/drivers/ni_labpc.c:980:9: error: implicit declaration of function 'virt_to_bus' [-Werror=implicit-function-declaration]
>

Stephen,

I just posted a patch that hopefully will fix this.

Please let me know if it works.

Regards,
Hartley

