Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3CNN7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:59:24 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57139 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3CNN7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:59:23 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 14 Mar 2013 06:59:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (pmbus) Fix krealloc() misuse in
 pmbus_add_attribute()
Message-ID: <20130314135927.GA16825@roeck-us.net>
References: <1363267820.4853.41.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363267820.4853.41.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 01:30:20PM +0000, David Woodhouse wrote:
> If krealloc() returns NULL, it *doesn't* free the original. So any code
> of the form 'foo = krealloc(foo, …);' is almost certainly a bug.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Good catch. Thanks a lot for the fix!

Guenter
