Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3KZNAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:00:43 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57742 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083Ab3KZNAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:00:40 -0500
Message-ID: <52949B73.3000206@hurleysoftware.com>
Date: Tue, 26 Nov 2013 08:00:35 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 7/7] n_tty: trace input/read flow control
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>	<1385135965-4235-8-git-send-email-peter@hurleysoftware.com> <20131124002513.0a806665@alan.etchedpixels.co.uk> <529166C0.8040001@hurleysoftware.com>
In-Reply-To: <529166C0.8040001@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 09:38 PM, Peter Hurley wrote:
> On 11/23/2013 07:25 PM, One Thousand Gnomes wrote:
>> On Fri, 22 Nov 2013 10:59:25 -0500
>> Peter Hurley <peter@hurleysoftware.com> wrote:
>>
>>> Instrument .receive_buf() and read() paths with trace_printk's
>>> to aid in debugging flow control changes.
>>
>> tty devices have a device, we have a dev_dbg() layer. The old tty trace
>> predates this but there isn't really any excuse for not using it now that
>> I can see ?
>
> I was using the ftrace facility because it has significantly less performance
> impact than printk (which was an important factor while debugging flow control
> problems).
>
> That said, I could further macro-ize n_tty_trace() with selectable facility
> (which would be useful when debugging problems that end in cpu death).

Greg,

I don't really mind if you don't want to take this patch; it is useful but
it does clutter up the code.

Regards,
Peter Hurley
