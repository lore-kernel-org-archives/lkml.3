Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaBGGoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 01:44:04 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:35029 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaBGGoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 01:44:01 -0500
Date: Fri, 7 Feb 2014 12:13:12 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 6/8] phy: st-miphy-40lp: Add SPEAr1310 and SPEAr1340
 PCIe phy support
Message-ID: <20140207064312.GC2414@pratyush-vbox>
References: <cover.1391661589.git.pratyush.anand@st.com>
 <dca9c501de8386003142b463469c3d267a049eeb.1391661589.git.pratyush.anand@st.com>
 <201402061637.05414.arnd@arndb.de>
 <20140207035429.GB2414@pratyush-vbox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140207035429.GB2414@pratyush-vbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Feb 07, 2014 at 11:54:30AM +0800, Pratyush ANAND wrote:
> Hi Arnd,
> 
> On Thu, Feb 06, 2014 at 11:37:05PM +0800, Arnd Bergmann wrote:
> > On Thursday 06 February 2014, Pratyush Anand wrote:
> > 

[...]

> > I think it's better to make this code table-driven. Rather than checking
> > 'of_device_is_compatible()', it's much easier to add a .data field to
> > the of_device_id array that describes the PHY. You can use .data to
> > point to a structure containing per-device function pointers or
> > (better) values and offsets to be used.

values and offset would be good as long as we do not need to write on
conditional read status. In our case its OK, as we do not need to
write conditionally. But, would it be a good idea to go that way?

Regards
Pratyush

> 
> Sounds a better idea. will reduce code size a lot. Thanks.
> 
> Regards
> Pratyush
> 
> > 
> > 	Arnd
