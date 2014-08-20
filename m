Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaHTQjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:39:16 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55908 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaHTQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:39:14 -0400
Message-ID: <53F4CF2E.2070605@cogentembedded.com>
Date: Wed, 20 Aug 2014 20:39:10 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: balbi@ti.com, Richard Leitner <richard.leitner@skidata.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] usb: gadget: serial: remove PREFIX macro
References: <20140718113946.0e70c0cb@lxbuild.skidata.net> <20140820155417.GD24500@saruman.home>
In-Reply-To: <20140820155417.GD24500@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/20/2014 07:54 PM, Felipe Balbi wrote:

>> Remove the ttyGS PREFIX macro from u_serial.c and replace all occurences with
>> the hardcoded ttyGS string.

>> This macro was mostly used in a few debug/warning messages and a lot of
>> hardcoded ttyGS existed beneath. It may have been used for renaming the
>> tty, but if done so most debug messages would have ignored this because
>> of the hardcoded strings.

>> Due to the fact the usage of this PREFIX instead of the hardcoded strings
>> in all debug calls would have resulted in a hard to read/grep code it
>> is removed completely.

>> Signed-off-by: Richard Leitner <richard.leitner@skidata.com>

> patch looks fine, can you resend with RFC in the subject ?

    s/with/without/?

WBR, Sergei

