Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaDEMaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 08:30:39 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:48270 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbaDEMah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 08:30:37 -0400
Message-ID: <533FF763.3020000@bergerie>
Date: Sat, 05 Apr 2014 14:30:27 +0200
From: Vincent <vincent.stehle@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] topology: Fix compilation warning when not in SMP
References: <1396593798-29173-1-git-send-email-vincent.stehle@laposte.net> <20140404234943.GA14633@kroah.com>
In-Reply-To: <20140404234943.GA14633@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2014 01:49 AM, Greg Kroah-Hartman wrote:
> Warnings aren't a stable kernel issue, so why would this be relevant
> there?

Oh, sorry about that. I'll go re-read the stable kernel rules again.

Shall I re-post without the stable Cc:, for only mainline and next?

Best regards,

V.

