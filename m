Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab3CDT1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:27:51 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:48058 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758603Ab3CDT1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:27:50 -0500
MIME-Version: 1.0
In-Reply-To: <51346287.9010801@freescale.com>
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>
	<1359349039-11510-2-git-send-email-b32955@freescale.com>
	<1360684037.12703.117.camel@sauron.fi.intel.com>
	<CAMiH66ExMK8rPMw3kvs9M2b-0ZSkfxBYteTi8QTZf+XCzJw5Dw@mail.gmail.com>
	<1362234094.2745.9.camel@sauron>
	<513437DF.2030505@freescale.com>
	<1362383434.2943.5.camel@sauron>
	<5134566C.2090405@freescale.com>
	<1362385446.2943.7.camel@sauron>
	<51345DFA.7070601@freescale.com>
	<1362386776.2943.11.camel@sauron>
	<51346287.9010801@freescale.com>
Date: Mon, 4 Mar 2013 11:27:49 -0800
Message-ID: <CAN8TOE_pE7o8hmiprs++tW_SpjKrT6if84-tY=ZW5TbtNiFTog@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dedekind1@gmail.com, Huang Shijie <shijie8@gmail.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 12:59 AM, Huang Shijie <b32955@freescale.com> wrote:
> 于 2013年03月04日 16:46, Artem Bityutskiy 写道:
>
>> Thanks, I forgot we have this great table. BTW, please, do not forget to
>> update it with information about these 4 chip you are adding,
>> irrespective of the solution we end up with.
>
> I also want to update the table, but i do not know how to do it.

You can send patches against the mtd-www.git repo. It's just a CSV
text-file, so you'd add a few rows. I'll try to review / ack any
patches.

Brian
