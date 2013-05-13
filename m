Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3EMSUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 14:20:24 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:61873 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3EMSUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 14:20:23 -0400
Message-ID: <51912EE2.6040909@gmail.com>
Date: Mon, 13 May 2013 20:20:18 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com> <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com> <20130510212422.GY3200@sirena.org.uk> <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local> <20130512143344.GC3200@sirena.org.uk> <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local> <20130513052135.GD6836@sirena.org.uk> <0bf5a185-86f7-4a93-a90f-42caefb06a1d@TX2EHSMHS009.ehs.local> <519112F9.2010102@gmail.com> <20130513181625.GB14811@sirena.org.uk>
In-Reply-To: <20130513181625.GB14811@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/13 20:16, Mark Brown wrote:
> On Mon, May 13, 2013 at 06:21:13PM +0200, Sebastian Hesselbarth wrote:
>> what Mark wants to point out is that you add fabric clocks to the Xilinx
>> driver instead. This way, you will have user-space controllable clocks
>> but only if you loaded the xilinx driver first.
>
> Yup, that's part of it.  Though I have to say that if all we can do is
> stuff a bitstream in there there is the question about how anything that
> does require a real driver gets that driver instantiated...

Back when I played with Zynq, I remember looking at CONFIG_DYNAMIC_OF
discussions. ;)

Sebastian
