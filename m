Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaJRK4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 06:56:35 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:47462 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaJRK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 06:56:34 -0400
Message-ID: <54424759.2010705@xs4all.nl>
Date: Sat, 18 Oct 2014 12:56:25 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Chuck Ebbert <cebbert.lkml@gmail.com>
CC: Peter Hurley <peter@hurleysoftware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CRASH during boot 3.16.3+
References: <543A88E4.4060707@xs4all.nl>	<543ABD7D.5010308@hurleysoftware.com>	<543BA610.8010001@xs4all.nl> <20141013072632.07b8fa64@as>
In-Reply-To: <20141013072632.07b8fa64@as>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-13 14:26, Chuck Ebbert wrote:
>> How can I capture the output easily?
> 
> Add "boot_delay=3000" to the kernel command line. This will add a 3
> second delay between each line. Then take pictures of the screen
> while it boots. And try to time the shots so you take them during the
> delays.

On the first system I tested (one that I do not really mind rebooting)
this parameter appears to have no effect.

Kind regards,
Udo



