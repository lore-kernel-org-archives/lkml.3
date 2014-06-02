Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaFBBCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 21:02:48 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:48251 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaFBBCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 21:02:47 -0400
Message-ID: <538BCD34.3020203@xs4all.nl>
Date: Mon, 02 Jun 2014 03:02:44 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.14.1 network issue with rtl81xx chip
References: <538B2502.5070707@xs4all.nl> <20140601174205.GA2027@electric-eye.fr.zoreil.com>
In-Reply-To: <20140601174205.GA2027@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-01 19:42, Francois Romieu wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> :
> [...]
>> On two boxes with rtl network chip I see connections going down.
> 
> Do you notice netdev watchdog messages in the kernel log ?

I do not see messages that look like that.

>> 3.14.1 has the issue.
> 
> Does it qualify as a (recent ?) regression or is it a fresh new setup ?

This machine has been running for over a year and some time ago the
problem occurred.
Same for the other problem machine which is even older.

Udo
