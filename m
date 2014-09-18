Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbaIRToj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:44:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41096 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaIRToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:44:38 -0400
Message-ID: <541B361C.4090302@oracle.com>
Date: Thu, 18 Sep 2014 15:44:28 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] firmware_class: make sure fw requests contain a name
References: <20140918182537.GA10260@www.outflux.net>
In-Reply-To: <20140918182537.GA10260@www.outflux.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 02:25 PM, Kees Cook wrote:
> An empty firmware request name will trigger warnings when building
> device names. Make sure this is caught earlier and rejected.
> 
> The warning was visible via the test_firmware.ko module interface:
> 
> echo -ne "\x00" > /sys/devices/virtual/misc/test_firmware/trigger_request
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org

Works for me!

	Tested-by: Sasha Levin <sasha.levin@oracle.com>


Thanks,
Sasha
