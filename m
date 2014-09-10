Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaIJGeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:34:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43521 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaIJGeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:34:24 -0400
MIME-Version: 1.0
In-Reply-To: <540FC7C8.1070904@gmail.com>
References: <CACVXFVN6f3Og+D_70M+4j_qhGNsryJWzTJK8G+rY0sxXweMqQg@mail.gmail.com>
	<540FC7C8.1070904@gmail.com>
Date: Wed, 10 Sep 2014 14:34:20 +0800
Message-ID: <CACVXFVOFci3572cJ=G8vAQ0-R_0A9rcDUcwa-8t0rjuGduJdwg@mail.gmail.com>
Subject: Re: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata controller
From: Ming Lei <ming.lei@canonical.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gaurav <gspatel@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:38 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 01/09/14 02:22 AM, Ming Lei wrote:
>>
>> Hi Guys,
>>
>> When we use hdparm to download firmware on system with
>> Marvell 88SE9125 SATA controller, it returns failure always
>> and it has been observed in several systems:
>>
>> #hdparm --fwdownload-mode7 fw.bin
>> --yes-i-kno-what-i-am-doing --please-destroy-my-drive /dev/sda
>>
>> /dev/sda:
>> fwdownload: xfer_mode=7 min=1 max=65535 size=699392
>> FAILED: Input/output error
>
>
> Any errors in dmesg after doing this?

No any failure log from kernel.

Thanks,
