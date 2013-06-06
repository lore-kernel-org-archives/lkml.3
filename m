Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3FFPgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:36:49 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:48421 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326Ab3FFPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:36:48 -0400
Message-ID: <51B0AC8D.3070708@itdev.co.uk>
Date: Thu, 06 Jun 2013 16:36:45 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix null pointer dereference caused by sysfs_notify on
 binary attribute
References: <1370511920-8628-1-git-send-email-nick.dyer@itdev.co.uk> <20130606152612.GA7495@kroah.com>
In-Reply-To: <20130606152612.GA7495@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jun 06, 2013 at 10:45:20AM +0100, Nick Dyer wrote:
>> It would be nice to have this work as expected but for now this is a minimal
>> fix to prevent the kernel panic.
> 
> Is anyone calling sysfs_notify on a binary attribute today?  Or can this
> go into 3.11?

Nope. I think I'm the first person to try it. So 3.11 is fine.
