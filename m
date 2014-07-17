Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaGQAyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:54:25 -0400
Received: from blu004-omc2s4.hotmail.com ([65.55.111.79]:57176 "EHLO
	BLU004-OMC2S4.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbaGQAyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:54:19 -0400
X-TMN: [/IutaUPCv8fSXP0jXgV8TATfd9sjWlWQk7ylc2o/7x8=]
X-Originating-Email: [beanhuo@outlook.com]
Message-ID: <BLU185-W53748517956B27745D7033A6F40@phx.gbl>
From: Bean Huo <beanhuo@outlook.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>
Subject: RE: [PATCH v6] mtd:nor:timeout:fix do_write_buffer() timeout error
Date: Thu, 17 Jul 2014 00:54:17 +0000
Importance: Normal
In-Reply-To: <20140716180423.GV7537@ld-irv-0074>
References: <BLU436-SMTP223B6F83933407357F0FF3BA6F70@phx.gbl>,<20140716180423.GV7537@ld-irv-0074>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 17 Jul 2014 00:54:18.0188 (UTC) FILETIME=[A35B88C0:01CFA159]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> Hi Bean,

>> + cfi->chips[i].buffer_write_time_max =
>> + ((cfi->chips[i].buffer_write_time_max>= 2000)
>> + ? cfi->chips[i].buffer_write_time_max : 2000);
>
> This should just use the 'max()' macro, from <linux/kernel.h>.

> I have just fixed up your patch myself, to use max() and to improve some
> of the language. Let me know if the below works for you.

hi,Brian
 Thanks once again.I test and it works Ok.It can be accepted now? 		 	   		  