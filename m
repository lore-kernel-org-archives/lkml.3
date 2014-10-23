Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaJWJxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:53:55 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:65531 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaJWJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:53:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141023094053.GA30334@kroah.com>
References: <1414054344-3688-1-git-send-email-Russ.Dill@gmail.com>
	<20141023094053.GA30334@kroah.com>
Date: Thu, 23 Oct 2014 11:53:49 +0200
Message-ID: <CAH6sp9OepN11f1bFUUgHgRSLtkvcD=GfrFX_sqPzT1YM1Vb=VA@mail.gmail.com>
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R devices
From: Frans Klaver <fransklaver@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: russ.dill@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 11:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Oct 23, 2014 at 01:52:24AM -0700, russ.dill@gmail.com wrote:
>> From: Russ Dill <Russ.Dill@gmail.com>
>>
>> This patch provides the FTDI genuine product verification steps
>> as contained within the new 2.12.00 official release. It ensures
>> that counterfeiters don't exploit engineering investment made
>> by FTDI. Counterfeit ICs are destroying innovation in the
>> industry.
>>
>> FTDI recommends that to guarantee genuine FTDI products
>> please purchase either from FTDI directly or an authorised
>> distributor.
>>
>> This is definitely not targeting end users - if you're unsure if
>> ICs are genuine then please don't use the drivers.
>>
>> Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
>> ---
>>  drivers/usb/serial/ftdi_sio.c | 111 +++++++++++++++++++++++++++++++++++++++++-
>>  drivers/usb/serial/ftdi_sio.h |  41 ++++++++++++++++
>>  2 files changed, 151 insertions(+), 1 deletion(-)
>
> Funny patch, you should have saved it for April 1, otherwise people
> might have actually taken this seriously :)
>
> Patches as performance art, now I've seen everything...

This just made my day :)
