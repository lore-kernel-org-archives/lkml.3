Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab3KXCCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 21:02:07 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49482 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755708Ab3KXCCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 21:02:02 -0500
Message-ID: <52915E14.7000703@hurleysoftware.com>
Date: Sat, 23 Nov 2013 21:01:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 5/7] n_tty: Refactor input_available_p() by call
 site
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>	<1385135965-4235-6-git-send-email-peter@hurleysoftware.com> <20131124002650.74902872@alan.etchedpixels.co.uk>
In-Reply-To: <20131124002650.74902872@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 07:26 PM, One Thousand Gnomes wrote:
> On Fri, 22 Nov 2013 10:59:23 -0500
> Peter Hurley <peter@hurleysoftware.com> wrote:
>
>> Distinguish if caller is n_tty_poll() or n_tty_read(), and
>> set the read/wakeup threshold accordingly.
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>
> Doh ignore previous.. yes that patch is right.  I should pay attention to
> 0/7 8)

Maybe I should add more to the commit message from the cover letter
description ?

