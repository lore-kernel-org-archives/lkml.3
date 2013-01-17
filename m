Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3AQJ7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:59:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53336 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759416Ab3AQJ7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:59:21 -0500
Message-ID: <50F7CB70.5010003@ti.com>
Date: Thu, 17 Jan 2013 10:59:12 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport power
 functions
References: <1358372702-13102-1-git-send-email-coelho@ti.com>  <50F7C4A7.5060202@ti.com> <1358415316.6252.20.camel@cumari.coelho.fi>
In-Reply-To: <1358415316.6252.20.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

On 01/17/2013 10:35 AM, Luciano Coelho wrote:
>> I just wonder how this is going to work with DT... You are not going to have
>> the ability to use callback in this form.
>> I think the GPIO handling should be done in the driver itself rather than in
>> the board file.
> 
> I agree.  The problem is that it used to be in the ti-st driver itself,
> but it has been removed in a patch that says "different platforms have
> begun to have their own ways to power-up/down the chip." (eccf2979
> drivers/misc/ti-st: remove gpio handling).

Hrm, this is a strange patch for sure. Coming at times when we all suppose to
move to DT and get rid of such callbacks for drivers.

> This needs to be clarified first.  I think we could use this for now and
> later fix this properly (hopefully move it back to the ti-st driver).

Can the offending patch be reverted?
As I said to Felipe, I don't have any objections against this patch. It fits
the purpose. But with the DT support (and removing callbacks to platform code)
you are going to have fair amount work.

-- 
Péter
