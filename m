Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaLOLa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:30:27 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41286 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLOLaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:30:25 -0500
Message-ID: <548EC64D.6000104@suse.cz>
Date: Mon, 15 Dec 2014 12:30:21 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Farthing <rfarthing@iee.org>, Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel boot panic 3.12-34 > 3.12.35
References: <548DAFA0.1090700@iee.org> <20141214182518.GA607@pd.tnic> <548EA9B5.70602@suse.cz> <548EB292.4080801@iee.org>
In-Reply-To: <548EB292.4080801@iee.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014, 11:06 AM, Richard Farthing wrote:
> I installed the kernel via YAST2 which makes and installs the initrd
> too, and have done this many times before on this test machine, so it
> seems unlikely to be my mistake, but it's always possible!  I will have
> a look at it again

Oh, yast... What about trying RPMs from
http://download.opensuse.org/repositories/Kernel:/SLE12/standard/
?

Either kernel-vanilla which is pure 3.12.35 (or later) or kernel-default
which is SLE12 kernel based on 3.12.35 (or later).

thanks,
-- 
js
suse labs
