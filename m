Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab3IFCzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 22:55:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55048 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3IFCzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 22:55:02 -0400
Date: Thu, 05 Sep 2013 22:54:58 -0400 (EDT)
Message-Id: <20130905.225458.830525929159444371.davem@davemloft.net>
To: sergei.shtylyov@cogentembedded.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <52290693.2010004@cogentembedded.com>
References: <20130905.164440.1477153216318239054.davem@davemloft.net>
	<52290693.2010004@cogentembedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 19:55:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Fri, 06 Sep 2013 02:32:51 +0400

> Hello.
> 
> On 09/06/2013 12:44 AM, David Miller wrote:
> 
>> Several bug fixes (from Kirill Tkhai, Geery Uytterhoeven, and Alexey
>> Dobriyan) and some support for Fujitsu sparc64x chips (from Allen
>> Pais).
> 
>> Please pull, thanks a lot!
> 
>    You meant that for 'linux-sparc', not 'linux-ide', right? :-)

Yes, sparclinux is the intended destination, and I forwarded it there
once I realized my mistake :-)
