Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaCFVl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:41:56 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51715 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaCFVlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:41:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140306195142.GA3403@kroah.com>
References: <1394024676-35160-1-git-send-email-maxin.john@enea.com>
	<20140305185048.GC26722@mwanda>
	<20140306195142.GA3403@kroah.com>
Date: Thu, 6 Mar 2014 22:41:54 +0100
Message-ID: <CAMhs6YzPcTnLO2rwny0binzLFT+TNJUwVhintGHYitgJ4=kiaQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] lustre/mdc_lib: fix possible null pointer dereference
From: "Maxin B. John" <maxin.john@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, Peng Tao <bergwolf@gmail.com>,
        alexey.zhuravlev@intel.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        josh@joshtriplett.org, jinshan.xiong@intel.com,
        "Maxin B. John" <maxin.john@enea.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 6, 2014 at 8:51 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 05, 2014 at 09:53:06PM +0300, Dan Carpenter wrote:
>> On Wed, Mar 05, 2014 at 02:04:35PM +0100, Maxin B. John wrote:
>> > From: "Maxin B. John" <maxin.john@enea.com>
>> >
>> > cppcheck reported possible null pointer dereference in mdc_lib.c
>> >
>> > [lustre/lustre/mdc/mdc_lib.c:233]: (error) Possible null pointer dereference
>> > : op_data - otherwise it is redundant to check if op_data is null at line 226
>> >
>>
>> There is only one caller and "op_data" is not NULL.
>
> I agree, John, please fix your tools.  Or check the result and fix the
> code so that there isn't false-positives (by not checking for NULL at
> all here...)

Thanks to Dan and Greg for the comments. Will try my best to avoid
these kind of mistakes in future.

> thanks,
> greg k-h

Best Regards,
Maxin
