Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3FEJiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:38:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60672 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab3FEJit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:38:49 -0400
Message-ID: <51AF071D.2050002@ti.com>
Date: Wed, 5 Jun 2013 12:38:37 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] USB: PHY: Improve PHY selection logic
References: <1369999743-11758-1-git-send-email-rogerq@ti.com> <20130603174709.GA11059@kroah.com> <51AD9462.4020300@ti.com> <20130604202632.GF28302@arwen.pp.htv.fi>
In-Reply-To: <20130604202632.GF28302@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 11:26 PM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jun 04, 2013 at 10:16:50AM +0300, Roger Quadros wrote:
>> On 06/03/2013 08:47 PM, Greg KH wrote:
>>> On Fri, May 31, 2013 at 02:29:01PM +0300, Roger Quadros wrote:
>>>> Hi,
>>>>
>>>> Improve Kconfig so that the relevant PHY driver can be explicitely
>>>> selected by the controller driver instead of relying on the user
>>>> to do so.
>>>>
>>>> Detailed description in patch 1.
>>>
>>> Felipe needs to take these, not I.
>>>
>>
>> Felipe,
>>
>> Could you please take these if appropriate? Thanks.
> 
> it's for v3.11 merge window, right ? I think I'll enjoy the rest of my
> vacations before taking these patches ;-)
> 
> I'll be back on office next monday, cheers
> 

Yes these are for 3.11 so no hurry :). Didn't mean to interrupt your vacations.

cheers,
-roger
