Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbaKUIzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:55:44 -0500
Received: from svenfoo.org ([82.94.215.22]:58111 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaKUIzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:55:43 -0500
Message-ID: <546EFE07.8070600@zonque.org>
Date: Fri, 21 Nov 2014 09:55:35 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Harald Hoyer <harald.hoyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: kdbus: add header file
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-3-git-send-email-gregkh@linuxfoundation.org> <546EF913.8030207@gmail.com>
In-Reply-To: <546EF913.8030207@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,

On 11/21/2014 09:34 AM, Harald Hoyer wrote:
> On 21.11.2014 06:02, Greg Kroah-Hartman wrote:
>> From: Daniel Mack <daniel@zonque.org>
>> …
> 
>> +
>> +/**
>> + * enum kdbus_make_flags - Flags for KDBUS_CMD_{BUS,EP,NS}_MAKE
>> + * @KDBUS_MAKE_ACCESS_GROUP:	Make the device node group-accessible
>> + * @KDBUS_MAKE_ACCESS_WORLD:	Make the device node world-accessible
>> + */
>> +enum kdbus_make_flags {
>> +	KDBUS_MAKE_ACCESS_GROUP		= 1ULL <<  0,
>> +	KDBUS_MAKE_ACCESS_WORLD		= 1ULL <<  1,
>> +};
>> +
> 
> "device node"

Yes, these are indeed oversights from the old implementation. Fixed now
upstream, along with the other details in kdbus.txt and some more
elsewhere in the tree.


Thanks,
Daniel

