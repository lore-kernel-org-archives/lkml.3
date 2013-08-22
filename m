Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3HVHdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:33:03 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:44931 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3HVHdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:33:01 -0400
X-Fcrdns: No
Message-ID: <5215BEA4.6040101@profihost.ag>
Date: Thu, 22 Aug 2013 09:32:52 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
References: <520C788A.1060208@profihost.ag> <520DFAB4.1050402@profihost.ag> <52114614.4070509@profihost.ag> <20130819222718.GA32104@kmo-pixel> <52132243.8050803@profihost.ag> <521323D1.1070503@profihost.ag> <20130821234715.GA4630@moria.home.lan> <5215A130.9080508@profihost.ag> <20130822054336.GA14935@kmo-pixel> <5215A8A8.90900@profihost.ag> <20130822060215.GB14935@kmo-pixel>
In-Reply-To: <20130822060215.GB14935@kmo-pixel>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

great!

Everything seems to work fine now! Except read_dirty always going to
negative values after a reboot.

Stefan

Am 22.08.2013 08:02, schrieb Kent Overstreet:
> On Thu, Aug 22, 2013 at 07:59:04AM +0200, Stefan Priebe wrote:
>>
>>> schedule_timeout() is not the same as
>>> schedule_timeout_interruptible().
>>
>> just search and replace? So i can try on my own.
> 
> The one in read_dirty(), line ~330
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
