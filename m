Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab3FDHRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:17:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35674 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3FDHQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:16:58 -0400
Message-ID: <51AD9462.4020300@ti.com>
Date: Tue, 4 Jun 2013 10:16:50 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] USB: PHY: Improve PHY selection logic
References: <1369999743-11758-1-git-send-email-rogerq@ti.com> <20130603174709.GA11059@kroah.com>
In-Reply-To: <20130603174709.GA11059@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 08:47 PM, Greg KH wrote:
> On Fri, May 31, 2013 at 02:29:01PM +0300, Roger Quadros wrote:
>> Hi,
>>
>> Improve Kconfig so that the relevant PHY driver can be explicitely
>> selected by the controller driver instead of relying on the user
>> to do so.
>>
>> Detailed description in patch 1.
> 
> Felipe needs to take these, not I.
> 

Felipe,

Could you please take these if appropriate? Thanks.

cheers,
-roger
