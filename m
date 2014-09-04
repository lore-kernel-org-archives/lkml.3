Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaIDW3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:29:40 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:57384 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbaIDW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:29:39 -0400
Message-ID: <1409869776.5546.123.camel@x220>
Subject: Re: [4/5] IBM Akebono: Add the Akebono platform
From: Paul Bolle <pebolle@tiscali.nl>
To: Alistair Popple <alistair@popple.id.au>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Fri, 05 Sep 2014 00:29:36 +0200
In-Reply-To: <10214508.Vq3Ynjy2Co@mexican>
References: <1394077948-8395-5-git-send-email-alistair@popple.id.au>
	 <1398936447.4121.12.camel@x220> <10214508.Vq3Ynjy2Co@mexican>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 22:29:37.0071 (UTC) FILETIME=[B5A9B3F0:01CFC88F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alistair,

On Fri, 2014-05-02 at 10:35 +1000, Alistair Popple wrote:
> On Thu, 1 May 2014 11:27:27 Paul Bolle wrote:
> > On Thu, 2014-03-06 at 14:52 +1100, Alistair Popple wrote:
> > > This patch adds support for the IBM Akebono board.
> > > +	select IBM_EMAC_RGMII_WOL
> > 
> > The patch that added this symbol (and the related driver) was submitted
> > in https://lkml.org/lkml/2014/2/21/25 . It's not (yet) included in
> > linux-next. Is it queued somewhere else?
> 
> To be honest I'm not sure. I will follow this up on the netdev list.

I noticed that this symbol (and its driver) are still not in v3.17-rc3
nor in next-20140904. Any update on this?

Thanks,


Paul Bolle

