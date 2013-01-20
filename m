Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3ATKOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:14:03 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45920 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3ATKOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:14:00 -0500
Message-ID: <50FBC36A.7080009@suse.cz>
Date: Sun, 20 Jan 2013 11:14:02 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Cong Ding <dinggnu@gmail.com>, Mikael Starvik <starvik@axis.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: serial/crisv10.c: remove unnecessary null pointer
 check
References: <1358375444-13026-1-git-send-email-dinggnu@gmail.com> <1358375444-13026-2-git-send-email-dinggnu@gmail.com> <20130118133821.GQ23529@axis.com>
In-Reply-To: <20130118133821.GQ23529@axis.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 02:38 PM, Jesper Nilsson wrote:
> On Wed, Jan 16, 2013 at 11:30:44PM +0100, Cong Ding wrote:
>> The pointer tty is dereferened in line 3135, so it is not necessary to check
>> null again in line 3140.
> 
> I don't know if we actually need to check the parameter tty from being null,
> but when checking the rest of the file, most other functions don't check it.

Yes, the check in unneeded.

thanks,
-- 
js
suse labs
