Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaKKVpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:45:21 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41429 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaKKVpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:45:17 -0500
Message-ID: <5462833A.5050706@gmail.com>
Date: Tue, 11 Nov 2014 23:44:26 +0200
From: Giedrius Statkevicius <giedriuswork@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: martink@posteo.de, linux-kernel@vger.kernel.org
Subject: Re: [Bisected] Regression: cpu stuck in gvfsd-fuse, can't shutdown
References: <5462713F.4080406@gmail.com> <20141111210506.GA26119@kroah.com>
In-Reply-To: <20141111210506.GA26119@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.11.11 23:05, Greg KH wrote:
> 
> If you revert this patch, does things go back to "normal" for you?

Originally I've only tested where the HEAD was
32eca22180804f71b06b63fd29b72f58be8b3c47 versus
32eca22180804f71b06b63fd29b72f58be8b3c47~1 but now I recompiled and
tested a vanilla 3.18.0-rc4-next-20141111 on which this issue occurs and
then tried a version with that particular patch reverted and then no
lockups happen.
