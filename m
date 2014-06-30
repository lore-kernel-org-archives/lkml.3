Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaF3JxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:53:11 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:48037 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaF3JxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:53:09 -0400
Message-ID: <53B13381.50400@suse.cz>
Date: Mon, 30 Jun 2014 11:53:05 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org
CC: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        #3.12@suse.de, Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc backport 3.12 1/2] mei: me: read H_CSR after asserting
 reset
References: <1404117830-1890-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1404117830-1890-1-git-send-email-tomas.winkler@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 10:43 AM, Tomas Winkler wrote:
> commit c40765d919d25d2d44d99c4ce39e48808f137e1e upstream.
> 
> According the spec the host should read H_CSR again
> after asserting reset H_RST to ensure that reset was
> read by the firmware
> 
> Cc: stable@vger.kernel.org #3.12

Thanks, now pushed.


-- 
js
suse labs
