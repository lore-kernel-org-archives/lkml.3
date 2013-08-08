Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966108Ab3HHSig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:38:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50698 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab3HHSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:38:35 -0400
Message-ID: <5203E5A7.7060108@gmail.com>
Date: Thu, 08 Aug 2013 11:38:31 -0700
From: Brian Norris <computersforpeace@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: dedekind1@gmail.com, Huang Shijie <shijie8@gmail.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>				 <1359349039-11510-2-git-send-email-b32955@freescale.com>				 <1360684037.12703.117.camel@sauron.fi.intel.com>				 <CAMiH66ExMK8rPMw3kvs9M2b-0ZSkfxBYteTi8QTZf+XCzJw5Dw@mail.gmail.com>			 <1362234094.2745.9.camel@sauron> <513437DF.2030505@freescale.com>		 <1362383434.2943.5.camel@sauron> <5134566C.2090405@freescale.com>	 <1362385446.2943.7.camel@sauron> <51345DFA.7070601@freescale.com> <1362386776.2943.11.camel@sauron> <51346287.9010801@freescale.com>
In-Reply-To: <51346287.9010801@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

For some reason, I just noticed your question here. But I think it's 
important to answer.

On 03/04/2013 12:59 AM, Huang Shijie wrote:
> 于 2013年03月04日 16:46, Artem Bityutskiy 写道:
>> Thanks, I forgot we have this great table. BTW, please, do not forget to
>> update it with information about these 4 chip you are adding,
>> irrespective of the solution we end up with.
> I also want to update the table, but i do not know how to do it.

You can submit a patch against mtd-www.git. See:

http://www.linux-mtd.infradead.org/faq/general.html#L_mtdwww

You just need to edit the CSV table under nand-data/nanddata.csv.

Brian
