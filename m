Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaJXS5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:57:25 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:54479 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaJXS5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:57:24 -0400
Date: Fri, 24 Oct 2014 22:57:19 +0400
From: Dmitry Voytik <voytikd@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Balavasu <kp.balavasu@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: lustre: lnet: lnet: do not initialise 0
Message-ID: <20141024185719.GA10175@ubuntuvm>
References: <20141018040330.GA23492@vasu-Inspiron-3542>
 <54429DAB.4060906@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54429DAB.4060906@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 09:04:43PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 10/18/2014 8:03 AM, Balavasu wrote:
> 
> >-static int check_routers_before_use = 0;
> >+static int check_routers_before_use = {0};
> 
>    Eh? I thought {} is only for arrays/structures...

It seems like this is from C++. In C++11 you can even drop '=' like
this:
	int i {0};
;)

WBR,
voyt
