Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaJ1NVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:21:38 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:4855 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaJ1NVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:21:35 -0400
Message-ID: <544F985C.9020905@imgtec.com>
Date: Tue, 28 Oct 2014 13:21:32 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <alsa-devel@alsa-project.org>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 00/11] Add AXD Audio Processing IP driver
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com> <544F86C1.8040500@metafoo.de>
In-Reply-To: <544F86C1.8040500@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 12:06 PM, Lars-Peter Clausen wrote:
> On 10/28/2014 12:26 PM, Qais Yousef wrote:
>> AXD Audio Processing IP performs audio decoding, encoding, mixing, 
>> equalisation,
>> synchronisation and playback. This series adds the driver and DT binding
>> document.
>> [...]
>> I added it to drivers/char as this is the best location I could think 
>> of at the
>> moment. It doesn't fit in alsa subsystem but I Cced them to confirm.
> > [...]
>
> I think it will fit in nicely.
>
> - Lars
>
Check my answer to Clemens.

Thanks,
Qais
