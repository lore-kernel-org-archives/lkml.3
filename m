Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaG2JUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:20:23 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:33565 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751587AbaG2JUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:20:21 -0400
Message-ID: <53D7674B.1070405@daenzer.net>
Date: Tue, 29 Jul 2014 18:20:11 +0900
From: =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Steven Chamberlain <steven@pyro.eu.org>
CC: Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Random panic in load_balance() with 3.16-rc
References: <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>	<20140723155526.GW3935@laptop>	<CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>	<20140723170324.GZ3935@laptop>	<CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>	<CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>	<20140723182518.GD3935@laptop>	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>	<20140723184111.GG3935@laptop>	<CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>	<20140723190230.GH3935@laptop>	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>	<53D064C7.5050807@daenzer.net> <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com> <53D1B1EF.7030603@daenzer.net> <53D3ED27.7080607@pyro.eu.org>
In-Reply-To: <53D3ED27.7080607@pyro.eu.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.07.2014 03:02, Steven Chamberlain wrote:
> On 25/07/14 02:25, Michel Dänzer wrote:
>> Attached is fair.s from Debian gcc 4.8.3-5. Does that look better? I'm
>> going to try reproducing the problem with a kernel built by that now.
> 
> It looks like gcc-4.9 Debian package version 4.9.1-2 available in
> sid/jessie may have already fixed this (though Debian's buildd systems
> may not have been updated with it yet).  If you are able to test with
> that version and let us know, that would be wonderful.

I couldn't test 4.9.1-2, but 4.9.1-3 seems to fix the problem.


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
