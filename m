Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaIKMp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:45:27 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39245 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755437AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Message-ID: <541196BB.60407@hurleysoftware.com>
Date: Thu, 11 Sep 2014 08:34:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
References: <1410384499-4982-1-git-send-email-peter@hurleysoftware.com>	<20140911000343.GA5328@kroah.com>	<5410E8A2.5030802@hurleysoftware.com> <20140911111930.7227abbf@alan.etchedpixels.co.uk>
In-Reply-To: <20140911111930.7227abbf@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 06:19 AM, One Thousand Gnomes wrote:
>> It's not common knowledge (and its certainly counterintuitive) that
>> turning off output when output is already turned off (ie., tcflow(TCOOFF))
>> is the required trickery to unwedge a terminal.
>>
>> Unwedging directly seems the straightforward approach.
> 
> Putting the off/on in the man page might be safer still ?

That's my plan if this patch fails to launch.

Regards,
Peter Hurley

