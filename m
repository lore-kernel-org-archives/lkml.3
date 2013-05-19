Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3ESCMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 22:12:48 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37068 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3ESCMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 22:12:46 -0400
Message-ID: <51983532.7090300@gmail.com>
Date: Sun, 19 May 2013 10:13:06 +0800
From: Libo Chen <chenlibo.3@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Libo Chen <libo.chen@huawei.com>, Sonic.Zhang@analog.com,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH v2 0/2] i2c: fix two wrong mem release
References: <1368088044-20408-1-git-send-email-libo.chen@huawei.com> <20130517094301.GH17056@katana>
In-Reply-To: <20130517094301.GH17056@katana>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013-5-17 17:43, Wolfram Sang 写道:
> On Thu, May 09, 2013 at 04:27:22PM +0800, Libo Chen wrote:
>> >fix two wrong mem release
>> >
>> >* Changelog from v1:
>> >   * exchange out_error_no_irq and out_error_pin_mux  suggested by Sonic<Sonic.Zhang@analog.com>
>> >   * add some new tag , make code cleanly
> Thanks for the submission. I do think the proper solution would be to
> convert the drivers to use the devm_* mechanisms, though. You can check
> commit 857968434bb6dbda0911f38ec46b0c3d0c963771 ("i2c: davinci: update
> to devm_* API") as a reference.
>
> Thanks,
>
>     Wolfram

Hi, Wolfram

    It is a good idea. I will learn about it.

Thanks,
Libo
