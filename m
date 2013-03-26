Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab3CZAY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:24:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59160 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3CZAY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:24:26 -0400
Message-ID: <5150EAAC.8020304@ti.com>
Date: Mon, 25 Mar 2013 20:24:12 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, Nishanth Menon <nm@ti.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCHv2 09/12] staging: ti-soc-thermal: fix several kernel-doc
 warnings and error
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com> <1363704868-11843-10-git-send-email-eduardo.valentin@ti.com> <20130325182226.GA15717@kroah.com>
In-Reply-To: <20130325182226.GA15717@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-03-2013 14:22, Greg KH wrote:
> On Tue, Mar 19, 2013 at 10:54:25AM -0400, Eduardo Valentin wrote:
>> This patch updates the documentation to remove
>> all warnings and errors reported by scripts/kernel-doc.
>> Most are missing arguments due to wrong format.
>>
>> Cc: Nishanth Menon <nm@ti.com>
>>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>
> In the future, don't put empty lines between the Cc: and signed-off-by:
> lines please, I had to hand-edit all of these to fix that...

Ok. Sure.. My bad..

>
> greg k-h
>
>

