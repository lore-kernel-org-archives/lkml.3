Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbaGSCgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 22:36:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:40073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbaGSCgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 22:36:13 -0400
Message-ID: <53C9D997.7000409@kernel.org>
Date: Fri, 18 Jul 2014 22:36:07 -0400
From: Sasha Levin <sashal@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, gregkh@linuxfoundation.org
CC: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        dan.j.williams@intel.com, valentine.barshak@cogentembedded.com,
        ming.lei@canonical.com, michael.opdenacker@free-electrons.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-core: Remove Fix mes in file hcd.c
References: <1405704880-10036-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1405704880-10036-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 01:34 PM, Nicholas Krause wrote:
> I am removing two fix mes in this file as after dicussing then it  seems
> there is no reason to check against Null for usb_device as it can never
> be NULL and this is check is therefore not needed.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Please explain exactly why it's not needed, why it can never be NULL, and
what prevents it from being NULL.

"after dicussing" (do you run spellcheck on your mails?) won't mean anything
to someone looking at this commit in a year.

Your commit message also mentions usb_device which has nothing to do with
your patch.


Thanks,
Sasha
