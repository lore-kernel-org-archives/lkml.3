Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3LDAOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:14:20 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55647 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754230Ab3LDAOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:14:18 -0500
Message-ID: <529E73D8.1000809@hurleysoftware.com>
Date: Tue, 03 Dec 2013 19:14:16 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: Convert termios to RCU (was Re: [PATCH tty-next 0/4] tty: Fix
 ^C echo)
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>	<20131203000116.0d512b59@alan.etchedpixels.co.uk>	<529D4E58.9020101@hurleysoftware.com> <20131203142011.371067ea@alan.etchedpixels.co.uk> <529E138C.4010503@hurleysoftware.com>
In-Reply-To: <529E138C.4010503@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 12:23 PM, Peter Hurley wrote:
> On 12/03/2013 09:20 AM, One Thousand Gnomes wrote:
>> As a PS: I think the termios is probably an RCU problem. The semaphore
>> seemed to make sense when I did it, but in hindsight I think I made the
>> wrong call.

Unfortunately, not without overhauling the console_lock().


