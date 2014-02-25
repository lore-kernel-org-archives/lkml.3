Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaBYHWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:22:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54477 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaBYHWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:22:37 -0500
Message-ID: <530C44B6.4050902@ti.com>
Date: Tue, 25 Feb 2014 09:22:30 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [RFC] drivercore: deferral race condition fix
References: <1387802491-14513-1-git-send-email-peter.ujfalusi@ti.com> <20140224014032.GT25940@sirena.org.uk> <20140224172251.GA30194@kroah.com>
In-Reply-To: <20140224172251.GA30194@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 07:22 PM, Greg Kroah-Hartman wrote:
> On Mon, Feb 24, 2014 at 10:40:32AM +0900, Mark Brown wrote:
>> On Mon, Dec 23, 2013 at 02:41:31PM +0200, Peter Ujfalusi wrote:
>>
>>> The proposed solution is to try the deferred queue once more when the last
>>> driver is asking for deferring and we had drivers probed while this last
>>> driver was probing.
>>
>> Greg, this patch doesn't seem to have been applied but it looks like
>> it's addressing a real issue and seems like a reasonable fix?  Peter's
>> analysis seems good to me.
> 
> I really don't remember, it's not in my queue anymore, as I can't apply
> [RFC] patches :(

Do you want me to resend as a patch?

-- 
Péter
