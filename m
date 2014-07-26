Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaGZSne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 14:43:34 -0400
Received: from manchester-1.man.uk.cluster.ok24.net ([213.138.100.64]:37927
	"EHLO manchester-1.man.uk.cluster.ok24.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbaGZSnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 14:43:33 -0400
X-Greylist: delayed 2466 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2014 14:43:33 EDT
Message-ID: <53D3ED27.7080607@pyro.eu.org>
Date: Sat, 26 Jul 2014 19:02:15 +0100
From: Steven Chamberlain <steven@pyro.eu.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@daenzer.net>
CC: Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Random panic in load_balance() with 3.16-rc
References: <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>	<20140723155526.GW3935@laptop>	<CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>	<20140723170324.GZ3935@laptop>	<CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>	<CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>	<20140723182518.GD3935@laptop>	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>	<20140723184111.GG3935@laptop>	<CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>	<20140723190230.GH3935@laptop>	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>	<53D064C7.5050807@daenzer.net> <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com> <53D1B1EF.7030603@daenzer.net>
In-Reply-To: <53D1B1EF.7030603@daenzer.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michel,

On 25/07/14 02:25, Michel Dänzer wrote:
> Attached is fair.s from Debian gcc 4.8.3-5. Does that look better? I'm
> going to try reproducing the problem with a kernel built by that now.

It looks like gcc-4.9 Debian package version 4.9.1-2 available in
sid/jessie may have already fixed this (though Debian's buildd systems
may not have been updated with it yet).  If you are able to test with
that version and let us know, that would be wonderful.

Thank you,
Regards,
-- 
Steven Chamberlain
steven@pyro.eu.org
