Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab3EOO60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:58:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43230 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab3EOO6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:58:22 -0400
Message-ID: <5193A276.9030308@ti.com>
Date: Wed, 15 May 2013 20:27:58 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Kevin Hilman <khilman@linaro.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv5 1/2] driver: tty: serial: Move "uart_console" def to
 core header file.
References: <1367006686-3720-1-git-send-email-sourav.poddar@ti.com> <1367006686-3720-2-git-send-email-sourav.poddar@ti.com> <87vc79uezo.fsf@linaro.org> <20130426221817.GA28377@kroah.com> <51939EFD.60900@ti.com> <20130515145711.GA1796@kroah.com>
In-Reply-To: <20130515145711.GA1796@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 May 2013 08:27 PM, Greg KH wrote:
> On Wed, May 15, 2013 at 08:13:09PM +0530, Sourav Poddar wrote:
>> Hi Greg,
>> On Saturday 27 April 2013 03:48 AM, Greg KH wrote:
>>> On Fri, Apr 26, 2013 at 03:03:07PM -0700, Kevin Hilman wrote:
>>>> Hi Greg,
>>>>
>>>> Sourav Poddar<sourav.poddar@ti.com>   writes:
>>>>
>>>>> Move "uart_console" definition to serial core header file, so that it can be
>>>>> used by serial drivers.
>>>>> Get rid of the uart_console defintion from mpc52xx_uart driver.
>>>>>
>>>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>>> Cc: Felipe Balbi<balbi@ti.com>
>>>>> Cc: Rajendra nayak<rnayak@ti.com>
>>>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>>>>> Reviewed-by: Felipe Balbi<balbi@ti.com>
>>>> Can you queue up this patch (and 2/2)?  Once these are in, I will queue
>>>> up the corresponding arch/arm changes which can go independently.
>>>>
>>>> And feel free to add
>>>>
>>>> Reviewed-by: Kevin Hilman<khilman@linaro.org>
>>>> Tested-by: Kevin Hilman<khilman@linaro.org>
>>> I will do so after 3.10-rc1 is out, it is _way_ too late in the
>>> development cycle for me to add these to my trees right now, considering
>>> they are pretty much closed at the moment.
>>>
>> Do you want me to rebase this patches on top of 3.10-rc1?
> That would be great to have, thanks.
>
> greg k-h
Ok. Will do that and resend.
