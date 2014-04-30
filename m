Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181AbaD3W6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:58:31 -0400
Received: from blu0-omc1-s24.blu0.hotmail.com ([65.55.116.35]:10168 "EHLO
	blu0-omc1-s24.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965041AbaD3W63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:58:29 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2014 18:58:29 EDT
X-TMN: [NFUJPwoeQxLjXN28lAcVj6P772GcjBRx]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP74DF2254448A59324B6A1597410@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Helge Deller <deller@gmx.de>
In-Reply-To: <20140430212602.GA20601@p100.fritz.box>
Subject: Re: [PATCH] parisc,metag: Do not hardcode maximum userspace stack size
References: <20140430212602.GA20601@p100.fritz.box>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Wed, 30 Apr 2014 18:53:04 -0400
CC: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-metag@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 30 Apr 2014 22:53:20.0763 (UTC) FILETIME=[FBC99CB0:01CF64C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-Apr-14, at 5:26 PM, Helge Deller wrote:

> +	  processes when the stack grows upwards (currently only on parisc  
> and matag

"metag" is mispelled.

Dave
--
John David Anglin	dave.anglin@bell.net



