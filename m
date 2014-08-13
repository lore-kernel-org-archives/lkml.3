Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaHMCBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:01:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaHMCBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:01:52 -0400
Date: Wed, 13 Aug 2014 10:01:09 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: question regarding drivers/staging/rtl8821ae/rtl8821ae/dm.c
Message-ID: <20140813020109.GA4973@kroah.com>
References: <CAB78YHyvDOEbbcbBn7pXZ-VLs43trRPY=ei47WL+QoG8OgV=1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB78YHyvDOEbbcbBn7pXZ-VLs43trRPY=ei47WL+QoG8OgV=1w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 01:06:16AM +0530, Himangi Saraogi wrote:
> Hi,
> 
> In the file, I see the code:
> 
> void rtl8821ae_dm_set_tx_ant_by_tx_
> info(...) {
>   ...
>   if ((rtlefuse->antenna_div_type == CG_TRX_HW_ANTDIV) ||
>       (rtlefuse->antenna_div_type == CG_TRX_HW_ANTDIV)){
>      SET_TX_DESC_TX_ANT(pdesc, pfat_table->antsel_a[mac_id]);
>   }
> }
> 
> Here, there is a double test. It seems the second test must be for
> CGCS_RX_HW_ANTDIV or CG_TRX_SMART_ANTDIV but am not sure. Is the second test
> just redundant or a different constant must be used?

No idea, try asking the original developers of the code (hint, almost
impossible...)

sorry,

greg k-h
