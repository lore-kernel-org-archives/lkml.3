Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab3KHPy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:54:29 -0500
Received: from host171.canaca.com ([67.55.55.225]:47737 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab3KHPy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:54:26 -0500
Message-ID: <cff1cc7d90beecb0a36ff8e81215ec29.squirrel@mungewell.org>
In-Reply-To: <alpine.LNX.2.00.1311081414470.835@pobox.suse.cz>
References: <1383766244-2336-1-git-send-email-simon@mungewell.org>
    <alpine.LNX.2.00.1311081414470.835@pobox.suse.cz>
Date: Fri, 8 Nov 2013 10:54:24 -0500
Subject: Re: [PATCH 1/5] HID:hid-lg4ff: Scale autocentering force properly on
 Logitech wheel
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Simon Wood" <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Elias Vanderstuyft" <elias.vds@gmail.com>,
        =?iso-8859-1?Q?=22Michal_Mal=FD=22?= <madcatxster@prifuk.cz>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 6 Nov 2013, Simon Wood wrote:
>
>> Adjust the scaling and lineartity to match that of the Windows
>> driver (from MOMO testing).
>>
>> Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
>> Signed-off-by: Simon Wood <simon@mungewell.org>
>
> I have applied the series, thanks.

Thanks to all involved.
Simon

