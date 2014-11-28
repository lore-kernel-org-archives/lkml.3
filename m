Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaK1BUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:20:37 -0500
Received: from m50-132.163.com ([123.125.50.132]:36834 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaK1BUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:20:35 -0500
Message-ID: <5477CDD4.8000908@163.com>
Date: Fri, 28 Nov 2014 09:20:20 +0800
From: Huang Bo <huangbobupt@163.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] HID: add BETOP game controller force feedback support
References: <54768284.4060201@163.com> <alpine.LNX.2.00.1411271004260.23174@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1411271004260.23174@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DNGowED5X1bVzXdU3eUZAA--.889S3
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUYeHqDUUUU
X-Originating-IP: [123.126.33.253]
X-CM-SenderInfo: xkxd0wpere31rw6rljoofrz/xtbBogpS-FD+lUFnQgAAsZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 05:05 PM, Jiri Kosina wrote:
> except ...
thanks firstly.
1. tested the BETOP2185 gamecontroller, it really not need it.
2. check with engineers of Betop, they design only one report descriptor.

so I modify it.


