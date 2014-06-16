Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaFPGBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:01:11 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47481 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaFPGBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:01:09 -0400
Message-ID: <539E8820.1070507@gmail.com>
Date: Mon, 16 Jun 2014 11:31:04 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Drokin, Oleg" <oleg.drokin@intel.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<hpdd-discuss@lists.01.org>" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v3 1/7] staging: lustre: lclient: glimpse.c fixing coding
 style issues
References: <1402892916-5298-1-git-send-email-askb23@gmail.com> <B0C4F83C-ACD6-49D0-B841-DBE1CBE3F5FC@intel.com>
In-Reply-To: <B0C4F83C-ACD6-49D0-B841-DBE1CBE3F5FC@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> - result = +1; + result = + 1;
> This looks wrong.
> Here +1 is apparently meant as +1 (compare to -1) to underscore it's positive nature.
> If you wanted to drop the +, that'd be fine, I guess, but in your version it looks outright wrong to me (I tested and it compiles, though).
>
> Bye,
>     Oleg
Hi Oleg,

While testing the value of `result` still remains "+1", from the above
change.

I agree as suggested, its better to remove `+` and use `result = 1;`
makes it more readable.

Will redo this patch and send.

Cheers.
