Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128Ab3DCKsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:48:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18849 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760829Ab3DCKsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:48:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 03 Apr 2013 03:48:19 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 3 Apr 2013 16:18:13 +0530
Subject: RE: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
Thread-Topic: [PATCH] usb: host: tegra: Reset Tegra USB controller before
 init
Thread-Index: Ac4vtzsDm0V62DriQduW8oNObR+9kwAoTvKg
Message-ID: <D958900912E20642BCBC71664EFECE3E6E50BE4611@BGMAIL02.nvidia.com>
References: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com>
 <512F9F0B.1040303@wwwdotorg.org>
 <D958900912E20642BCBC71664EFECE3E6E4F7216C0@BGMAIL02.nvidia.com>
 <5134D210.3060405@wwwdotorg.org> <20130305003423.GA23996@kroah.com>
 <D958900912E20642BCBC71664EFECE3E6E50BE434F@BGMAIL02.nvidia.com>
 <515AF9E9.1020603@wwwdotorg.org>
In-Reply-To: <515AF9E9.1020603@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Tuesday, April 02, 2013 9:02 PM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
> 
> On 04/02/2013 01:12 AM, Venu Byravarasu wrote:
> >> gregkh@linuxfoundation.org wrote at Tuesday, March 05, 2013 6:04 AM:
> >> On Mon, Mar 04, 2013 at 09:55:44AM -0700, Stephen Warren wrote:
> >>> On 03/04/2013 12:55 AM, Venu Byravarasu wrote:
> >>>> Stephen Warren wrote at Thursday, February 28, 2013 11:47 PM:
> >>>>> On 02/27/2013 11:36 PM, Venu Byravarasu wrote:
> >>>>>> To clear any configurations made by U-Boot on Tegra USB controller,
> >>>>>> reset it before init in probe.
> ...
> >> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > Hi Greg,
> >
> > Stephen initially thought that the patch can be taken through tegra tree,
> along with
> > other patches posted at  http://marc.info/?l=linux-
> tegra&m=136361016003625&w=2 .
> > As some other issues are blocking that patch series, can this change be
> merged
> > independent of that patch series via USB tree?
> >
> > The original change can be seen at http://marc.info/?l=linux-
> usb&m=136203353205291&w=2
> 
> Venu, you should simply repost the patch; I'm sure its not in anyone's
> email inbox any more.
 
Resent the patch, with ACKs added.
Latest patch can be seen at: http://marc.info/?l=linux-tegra&m=136498598329081&w=2 

Thanks,
Venu
