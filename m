Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaK0Xdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:33:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24880 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK0Xdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:33:41 -0500
MIME-Version: 1.0
Message-ID: <a04f5f41-fd23-4028-bf83-fcd4aeb70cef@default>
Date: Thu, 27 Nov 2014 15:33:26 -0800 (PST)
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: <bp@suse.de>
Cc: <konrad.wilk@oracle.com>, <x86@kernel.org>, <gregkh@linuxfoundation.org>,
        <david.vrabel@citrix.com>, <stable@vger.kernel.org>,
        <rshendershot@mchsi.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- bp@suse.de wrote:

> On Thu, Nov 27, 2014 at 09:14:11AM -0800, Boris Ostrovsky wrote:
> > The overnight tests passed. This includes baremetal, HVM and PV(H),
> > 32- and 64-bit.
> 
> Cool. Want to send a proper patch for 3.18 and CC: stable?
> 

So I am not convinced that we actually update microcode on baremetal now. 

I will look into this but it would have to wait until Monday.

-boris
